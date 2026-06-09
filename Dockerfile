# Layer 1: The base image — we're starting from an official Python image
# "slim" means a stripped-down Debian OS with just Python, no extras
# This is pulled from Docker Hub the first time, then cached locally
FROM python:3.12-slim

# Layer 2: Set the working directory inside the container's filesystem
# All subsequent commands run from here; also where your app files will live
WORKDIR /app

# Layer 3: Copy ONLY the requirements file first (not your source code yet)
# Why? Because pip install is slow. If we copy everything at once,
# any code change would invalidate this layer and re-run pip install.
# By copying requirements.txt separately, pip install is only re-run
# when requirements.txt changes — not when main.py changes.
COPY requirements.txt .

# Layer 4: Install dependencies
# --no-cache-dir tells pip not to store the download cache inside the image
# (keeps the image smaller — we don't need it after install)
RUN pip install --no-cache-dir -r requirements.txt

# Layer 5: NOW copy your source code
# This layer changes frequently, but that's fine — it's cheap to copy files
COPY . .

# Document which port the app listens on (this is metadata, not a firewall rule)
EXPOSE 8000

# The command that runs when someone does `docker run <image>`
# We use uvicorn to serve the FastAPI app on all interfaces (0.0.0.0)
# 0.0.0.0 means "accept connections from outside the container", not just localhost
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
