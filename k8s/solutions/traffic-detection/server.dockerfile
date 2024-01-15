# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy your server application code into the container
COPY server_app.py /app/

# Install any necessary dependencies
# For example, if your server uses Flask:
# RUN pip install flask

# Expose the port that your server listens on
EXPOSE 5000

# Set the command to run your server when the container starts
CMD ["python", "server_app.py"]
