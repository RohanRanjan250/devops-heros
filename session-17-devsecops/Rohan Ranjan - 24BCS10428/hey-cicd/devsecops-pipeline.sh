#!/usr/bin/env bash
# Local version of .github/workflows/devsecops.yml - same stages, same gates.
# Any failing stage stops the script (set -e + pipefail), so nothing after it runs.
# Gates are standalone commands on purpose: `cmd && echo ok` would NOT trigger set -e.
# Usage: ./devsecops-pipeline.sh <tag>
set -euo pipefail

TAG="${1:?usage: $0 <image-tag>}"
REGISTRY="${REGISTRY:-localhost:5050/rohanranjan250}"
CLUSTER="${CLUSTER:-devops-heros}"

stage() { printf '\n==== [%s] %s ====\n' "$(date +%T)" "$1"; }

stage "1/7 unit tests"
python3 -m pytest -q --disable-warnings

stage "2/7 SAST (bandit, fail on MEDIUM+)"
bandit -r app -q --severity-level medium -f custom --msg-template "{relpath}:{line} {test_id} {severity} {msg}"
echo "SAST gate: PASSED"

stage "3/7 SCA (pip-audit)"
pip-audit -r requirements.txt
echo "SCA gate: PASSED"

stage "4/7 secret scan (gitleaks)"
gitleaks dir . --no-banner 2>&1 | tail -n 1
echo "secret gate: PASSED"

stage "5/7 build + image scan (trivy HIGH/CRITICAL, fixable)"
docker build -q -t "hey-cicd:${TAG}" .
trivy image -q --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
  --format json -o /dev/null "hey-cicd:${TAG}"
echo "image gate: PASSED"

stage "6/7 push (only reached when every gate passed)"
docker tag "hey-cicd:${TAG}" "${REGISTRY}/hey-cicd:${TAG}"
docker push -q "${REGISTRY}/hey-cicd:${TAG}"

stage "7/7 deploy + wait for rollout"
kind load docker-image "hey-cicd:${TAG}" --name "${CLUSTER}" >/dev/null
kubectl set image deployment/session17-python "session17-python=hey-cicd:${TAG}"
kubectl rollout status deployment/session17-python --timeout=120s

printf '\nPIPELINE PASSED - hey-cicd:%s is live\n' "${TAG}"
