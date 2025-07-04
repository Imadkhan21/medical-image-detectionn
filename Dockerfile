# Use official Python 3.10 base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Collect static files (optional, if using Whitenoise)
RUN python manage.py collectstatic --noinput

# Expose the port
EXPOSE 8000

# Start the application
CMD ["gunicorn", "medical_classification.wsgi:application", "--bind", "0.0.0.0:8000"]
