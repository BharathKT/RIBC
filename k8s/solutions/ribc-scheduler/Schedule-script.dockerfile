# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the scheduling script into the container
COPY schedule.py /app/

# Install any dependencies required by the script (if applicable)
# For example, if your script uses additional Python packages:
RUN pip install package1 package2

# Set the command to execute your script when the container starts
CMD ["python", "schedule.py"]
