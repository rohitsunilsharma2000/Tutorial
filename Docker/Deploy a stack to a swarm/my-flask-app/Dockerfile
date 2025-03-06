# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy application files
COPY app.py requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable to disable buffering
ENV PYTHONUNBUFFERED=1

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
