#!/bin/bash
#
# test_dashboard.sh
# Puts temporary load on the system (CPU + memory) and checks that the
# Netdata dashboard is reachable, so you can watch the charts react live.
#
# Usage: ./test_dashboard.sh

DURATION=30  # seconds of load to generate

echo "==> Checking that Netdata is reachable on port 19999..."
if curl -s --max-time 5 http://localhost:19999/api/v1/info > /dev/null; then
    echo "Netdata is responding locally."
else
    echo "ERROR: Netdata does not seem to be running. Run setup.sh first."
    exit 1
fi

echo "==> Generating CPU load for ${DURATION} seconds..."
if command -v stress > /dev/null; then
    # Use the 'stress' tool if it's installed
    stress --cpu 2 --timeout "${DURATION}s"
else
    echo "'stress' not found, falling back to a manual CPU-burning loop..."
    # Spin up a couple of background loops that just do math as fast as possible
    for i in 1 2; do
        ( timeout "${DURATION}" bash -c 'while true; do echo "$((1+1))" > /dev/null; done' ) &
    done
    wait
fi

echo "==> Load test finished."
echo "Open http://<server-ip>:19999 and check the CPU chart to see the spike."
