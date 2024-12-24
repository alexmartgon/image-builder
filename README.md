### IDEA:
I see that for my jenkins builds a lot of CPU is consumed from the pods on installation of virtual environments or ansible modules.

Solution is to have an image building flow with docker in docker to create my images to repositories (maybe private repositories one day but public for now) in docker hub. 

This scrypt will need:
    - The docker user and password (hidden with k8s secrets pulled in jenkinsfile)
    - The repository to use (WITH THE USERNAME SO alexmartgon/x)
    - The dockerfile to use
    - The image tag