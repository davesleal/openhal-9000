#!/usr/bin/env python3
"""OpenHAL 9000 TTS server (Docker fallback). Accepts text over TCP, returns raw s16le audio."""
import socket
import subprocess
import sys

MODEL = "/models/hal.onnx"
HOST = "0.0.0.0"  # Docker requires 0.0.0.0; host binding restricts to 127.0.0.1
PORT = 9090
MAX_INPUT_LEN = 10000
LENGTH_SCALE = 0.92  # Slightly faster speech rate (1.0 = default, lower = faster)


def synthesize(text: str) -> bytes:
    proc = subprocess.run(
        ["piper", "--model", MODEL, "--output_raw", "--length_scale", str(LENGTH_SCALE)],
        input=text.encode(),
        capture_output=True,
        timeout=30,
    )
    return proc.stdout


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((HOST, PORT))
        s.listen(1)
        print(f"OpenHAL 9000 TTS server listening on {HOST}:{PORT}", flush=True)
        while True:
            try:
                conn, _ = s.accept()
                with conn:
                    conn.settimeout(5.0)
                    data = conn.recv(MAX_INPUT_LEN + 1)
                    if data and len(data) <= MAX_INPUT_LEN:
                        audio = synthesize(data.decode("utf-8", errors="replace").strip())
                        conn.sendall(audio)
            except socket.timeout:
                continue
            except (subprocess.TimeoutExpired, OSError) as e:
                print(f"Error: {e}", file=sys.stderr, flush=True)
                continue


if __name__ == "__main__":
    main()
