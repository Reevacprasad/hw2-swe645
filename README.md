# Student Survey Web Application Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technologies Used](#technologies-used)
4. [Project Structure](#project-structure)
5. [Application Features](#application-features)
6. [Configuration](#configuration)
7. [CI/CD Pipeline](#cicd-pipeline)
8. [Deployment](#deployment)
9. [Development Setup](#development-setup)
10. [Usage Guide](#usage-guide)
11. [Troubleshooting](#troubleshooting)
12. [Security Considerations](#security-considerations)

## Project Overview

The Student Survey Web Application is a static HTML form designed to collect feedback from students about their campus experience. The application is containerized using Docker with Nginx as the web server and deployed on Kubernetes with automated CI/CD pipeline using Jenkins.

**Group:** Alpha1  
**Application Type:** Static Web Application  
**Primary Purpose:** Student survey data collection  

### Key Features
- Responsive HTML form for student surveys
- Client-side form validation
- Docker containerization with Nginx
- Kubernetes deployment with high availability
- Automated CI/CD pipeline with Jenkins
- Static asset serving (images, CSS, JavaScript)

## Architecture

The application follows a simple static web architecture:

```
┌─────────────────┐
│   Web Browser   │ ← User Interface
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  Load Balancer  │ ← Kubernetes Service (NodePort)
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  Nginx Pods     │ ← 3 Replicas serving static content
│  (Port 80)      │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  Static Files   │ ← HTML, CSS, JS, Images
│  (index.html)   │
└─────────────────┘
```

## Technologies Used

### Frontend
- **HTML5** - Markup language
- **CSS3** - Styling and layout
- **JavaScript** - Client-side functionality
- **Responsive Design** - Mobile-friendly interface

### Web Server
- **Nginx** - High-performance web server
- **Ubuntu Latest** - Base Docker image

### DevOps & Deployment
- **Docker** - Containerization
- **Kubernetes** - Container orchestration
- **Jenkins** - CI/CD pipeline
- **DockerHub** - Container registry

### Infrastructure
- **AWS EC2** - Kubernetes cluster hosting
- **Rancher** - Kubernetes management platform

## Project Structure

```
├── Dockerfile                    # Docker container configuration
├── Jenkinsfile                   # CI/CD pipeline definition
├── index.html                    # Main survey form
├── j.jpg                        # Background image asset
├── key-swe645.pem              # SSH private key for EC2 access
├── config                       # Kubernetes cluster configuration
├── deployment.yaml              # Kubernetes deployment manifest
└── service.yaml                # Kubernetes service manifest
```

## Application Features

### Survey Form Components

#### Personal Information Section
- **First Name*** - Required text input
- **Last Name*** - Required text input
- **Street Address*** - Required text input
- **City*** - Required text input
- **State*** - Required text input
- **ZIP Code*** - Required text input
- **Telephone Number*** - Required tel input with validation
- **Email Address*** - Required email input with validation
- **Survey Date*** - Required date picker

#### Campus Feedback Section
- **Campus Likes** - Multi-select checkboxes:
  - Students
  - Location
  - Campus
  - Atmosphere
  - Dorm Rooms
  - Sports

- **Interest Source** - Radio button selection:
  - Friends
  - Television
  - Internet
  - Other

- **Recommendation Likelihood** - Dropdown selection:
  - Very Likely
  - Likely
  - Unlikely

#### Additional Information
- **Raffle Numbers** - Text input for comma-separated numbers (1-100)
- **Additional Comments** - Textarea for free-form feedback

#### Form Controls
- **Submit Button** - Processes form and shows confirmation
- **Cancel Button** - Resets form and hides messages

### User Interface Features
- **Responsive Design** - Adapts to different screen sizes
- **Background Image** - Custom campus image (j.jpg)
- **Form Validation** - HTML5 required field validation
- **Success Messages** - User feedback on form submission
- **Form Reset** - Clear all fields functionality

## Configuration

### Docker Configuration (Dockerfile)
```dockerfile
FROM --platform=linux/amd64 ubuntu:latest 
RUN apt-get update && apt-get install -y nginx
RUN rm /var/www/html/index.nginx-debian.html 
COPY index.html /var/www/html/
COPY j.jpg /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Key Configuration Details:**
- **Base Image:** Ubuntu latest (AMD64 platform)
- **Web Server:** Nginx
- **Port:** 80
- **Document Root:** /var/www/html/
- **Static Assets:** index.html, j.jpg
- **Process:** Nginx runs in foreground mode

### Kubernetes Deployment (deployment.yaml)
```yaml
apiVersion: apps/v1 
kind: Deployment 
metadata:
  name: deployment
spec:
  replicas: 3 
  selector:
    matchLabels: 
      run: nginx
  template: 
    metadata:
      labels: 
        run: nginx
    spec: 
      containers:
      - name: container-hw2
        image: rprasad6/docker-img-hw2:1.0 
        ports:
        - containerPort: 80
```

### Kubernetes Service (service.yaml)
```yaml
apiVersion: v1 
kind: Service 
metadata:
  name: service-nodeportobj 
spec:
  type: NodePort 
  selector:
    run: nginx 
  ports:
    - port: 80
      targetPort: 80 
      protocol: TCP
      name: nodeportobj
```

## CI/CD Pipeline

### Jenkins Pipeline Overview
The pipeline consists of three main stages:

#### Stage 1: Build Survey Image
- Checkout source code from SCM
- Generate build timestamp for image tagging
- Login to DockerHub using stored credentials
- Build Docker image with timestamp tag

#### Stage 2: Push Image to Docker Hub
- Push the built image to DockerHub repository
- Image naming convention: `rprasad6/docker-img-hw2:{timestamp}`

#### Stage 3: Deploy to Kubernetes
- Update Kubernetes deployment with new image
- Deploy to default namespace using kubectl
- Use kubeconfig credentials for cluster access

### Environment Variables
```groovy
environment {
    DOCKERHUB_CREDENTIALS = credentials('docker')
    BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"
    KUBECONFIG_CREDENTIALS = credentials('kubeconfig')
}
```

### Required Jenkins Credentials
- **docker** - DockerHub username and password
- **kubeconfig** - Kubernetes cluster configuration file

### Pipeline Script Highlights
```groovy
// Docker build and tag
def customImage = docker.build("rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}")

// DockerHub push
sh "docker push rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}"

// Kubernetes deployment update
sh 'kubectl set image deployment/deployment container-hw2=rprasad6/docker-img-hw2:${BUILD_TIMESTAMP} -n default'
```

## Deployment

### Kubernetes Cluster Information
- **Cluster Name:** hw2-rancher
- **Management Platform:** Rancher
- **Server:** https://35.174.227.235/k8s/clusters/c-m-ffk66xjv
- **Namespace:** default

### Deployment Configuration
- **Replicas:** 3 instances for high availability
- **Container Port:** 80
- **Service Type:** NodePort for external access
- **Load Balancing:** Automatic across replicas

### Access Configuration
- **Internal Service Port:** 80
- **Target Container Port:** 80
- **Protocol:** TCP
- **External Access:** Via NodePort service

## Development Setup

### Prerequisites
- Docker installed
- Access to Kubernetes cluster
- Jenkins with required plugins
- Git repository access

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student-survey-app
   ```

2. **Test locally with Docker**
   ```bash
   # Build the image
   docker build -t survey-app .
   
   # Run container
   docker run -p 8080:80 survey-app
   
   # Access application
   open http://localhost:8080
   ```

3. **Modify the survey form**
   - Edit `index.html` for form changes
   - Update `j.jpg` for background image
   - Test changes locally before pushing

### File Modifications

#### Adding New Form Fields
```html
<!-- Add to index.html -->
<label for="newField">New Field*</label>
<input type="text" id="newField" required>
```

#### Updating Styles
```css
/* Add to <style> section in index.html */
.new-style {
    /* Your custom styles */
}
```

#### JavaScript Enhancements
```javascript
// Add to <script> section in index.html
function newFunction() {
    // Your custom functionality
}
```

## Usage Guide

### Accessing the Application
1. Navigate to the NodePort service URL
2. Fill out the survey form with required information
3. Submit the form to see confirmation message

### Form Completion Steps

#### Step 1: Personal Information
- Enter all required personal details
- Ensure email format is valid
- Use proper date format for survey date

#### Step 2: Campus Feedback
- Select multiple options for campus likes
- Choose one option for interest source
- Select recommendation likelihood

#### Step 3: Additional Information
- Enter raffle numbers (optional)
- Add any additional comments (optional)

#### Step 4: Submission
- Click "Submit" to process the form
- See confirmation message
- Use "Cancel" to reset if needed

### Form Validation
- **Required Fields:** Marked with asterisk (*)
- **Email Validation:** Automatic format checking
- **Date Validation:** Date picker ensures proper format
- **Phone Validation:** Tel input type for mobile optimization

## Troubleshooting

### Common Issues

#### Docker Build Failures
```bash
# Check Docker daemon
sudo systemctl status docker

# Verify Dockerfile syntax
docker build --no-cache -t test-image .

# Check image size
docker images
```

#### Kubernetes Deployment Issues
```bash
# Check pod status
kubectl get pods

# View pod logs
kubectl logs deployment/deployment

# Describe deployment
kubectl describe deployment deployment

# Check service
kubectl get services
```

#### Jenkins Pipeline Failures
```bash
# Common issues and solutions:

# 1. Docker login failures
# Verify DOCKERHUB_CREDENTIALS are configured correctly

# 2. Kubernetes access issues
# Ensure KUBECONFIG_CREDENTIALS contain valid cluster config

# 3. Image push failures
# Check DockerHub repository permissions
```

### Debugging Commands

#### Application Access Issues
```bash
# Get service details
kubectl get service service-nodeportobj

# Get node IP and port
kubectl get nodes -o wide
kubectl get service service-nodeportobj -o yaml

# Test internal connectivity
kubectl exec -it <pod-name> -- curl localhost:80
```

#### Static Asset Issues
```bash
# Check if files are copied correctly
kubectl exec -it <pod-name> -- ls -la /var/www/html/

# Verify Nginx configuration
kubectl exec -it <pod-name> -- nginx -t

# Check Nginx access logs
kubectl exec -it <pod-name> -- tail -f /var/log/nginx/access.log
```

### Error Scenarios

#### 404 Not Found
- Check if static files are properly copied to container
- Verify Nginx document root configuration
- Ensure service selector matches deployment labels

#### 502 Bad Gateway
- Check if pods are running and healthy
- Verify port configurations match
- Review Nginx configuration

#### Form Submission Issues
- Check browser console for JavaScript errors
- Verify form validation is working
- Test with different browsers

## Security Considerations

### Current Security Measures
- Container runs as non-root user (Nginx default)
- Static content only - no server-side processing
- Input validation on client-side

### Recommended Security Enhancements

#### Container Security
```dockerfile
# Add security improvements to Dockerfile
RUN adduser --system --no-create-home --shell /bin/false --group nginx
USER nginx
```

#### Network Security
- Implement HTTPS/TLS termination
- Use ingress controller with SSL certificates
- Restrict network policies

#### Data Security
- Implement server-side form processing
- Add CSRF protection
- Validate and sanitize all inputs
- Store form data securely

### Access Control
- **SSH Key Security:** The included private key should be rotated regularly
- **Kubernetes RBAC:** Implement role-based access control
- **Credential Management:** Use Kubernetes secrets for sensitive data

## Future Enhancements

### Functional Improvements
- **Backend Integration:** Connect to database for form storage
- **Email Integration:** Send confirmation emails
- **File Uploads:** Support for document attachments
- **Multi-language Support:** Internationalization

### Technical Improvements
- **Progressive Web App:** Add PWA capabilities
- **API Integration:** RESTful backend services
- **Real-time Validation:** Server-side validation
- **Analytics:** User interaction tracking

### Infrastructure Improvements
- **SSL/TLS:** HTTPS implementation
- **CDN Integration:** Static asset optimization
- **Monitoring:** Application performance monitoring
- **Backup Strategy:** Data backup and recovery

### Development Workflow
- **Testing:** Automated testing pipeline
- **Code Quality:** SonarQube integration
- **Documentation:** Automated documentation generation
- **Rollback Strategy:** Blue-green deployments

## Appendix

### Kubernetes Cluster Configuration
The cluster configuration includes:
- Certificate authority data for secure communication
- User authentication token
- Cluster endpoint URL
- Context configuration for kubectl

### Image Registry Details
- **Repository:** rprasad6/docker-img-hw2
- **Registry:** DockerHub
- **Tagging Strategy:** Timestamp-based versioning
- **Image Size:** Ubuntu base + Nginx + static assets

### Network Configuration
- **Internal Communication:** Pod-to-pod via cluster DNS
- **External Access:** NodePort service
- **Load Balancing:** Kubernetes service load balancer
- **Port Mapping:** 80 (container) → NodePort (external)
