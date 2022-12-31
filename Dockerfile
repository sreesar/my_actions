FROM ubuntu:18.04
RUN DEBIAN_FORNTEND=noninteractive apt update -y && apt install -y \
                                                                wget \
                                                                tree \
                                                                git \
                                                                 curl \
                                                              openssl \
                                                                 # for node-sass module
                                                               make  gcc g++ musl chromium-browser   ca-certificates

# set urls as trusted-host
ENV PYTHON_TRUST="--trusted-host pypi.org --trusted-host files.pythonhosted.org"

# Install required packages
RUN apt-get update -y && apt-get clean
RUN apt-get install sshpass dos2unix net-tools csh bc jq -y && apt-get clean
RUN apt-get install iputils-ping -y && apt-get clean
RUN apt-get install net-tools -y && apt-get clean
RUN apt-get install software-properties-common -y && apt-get clean

RUN apt-get update -y && apt-get clean
RUN apt-get install wget curl libgl1 protobuf-compiler -y  && apt-get clean
RUN add-apt-repository ppa:deadsnakes/ppa -y && apt-get clean
RUN apt-get install python3.8 -y && apt-get clean

# Latex additional packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y texlive-pictures texlive-science texlive-latex-extra latexmk

# Install pip3 and update
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
RUN ln -f /usr/bin/python3.8 /usr/bin/python3

# Install pip3 and update
RUN apt-get install python3-pip -y  && apt-get clean
RUN python -m pip install --upgrade pip  $PYTHON_TRUST
RUN apt-get install python3.8-venv -y  && apt-get clean
#Node and NPM configuration
RUN cd /usr/local/ && wget https://nodejs.org/dist/v16.13.0/node-v16.13.0-linux-x64.tar.xz && tar -xf  node-v16.13.0-linux-x64.tar.xz
ENV PATH /usr/local/node-v16.13.0-linux-x64/bin:$PATH
# Set up the application directory
VOLUME ["/home"]
WORKDIR /home

# Install node packages
RUN npm install -g typescript
# for scully / puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV SCULLY_PUPPETEER_EXECUTABLE_PATH '/usr/bin/chromium-browser'


# versions
RUN ls -al /home/
RUN node --version
RUN npm --version
RUN tsc --version
RUN python --version


CMD ["npm", "-v"]
#ENTRYPOINT ["tail"]
#ENTRYPOINT ["-f", "/dev/null"]
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /home/entrypoint.sh
RUN chmod 777 /home/entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)

ENTRYPOINT ["/home/entrypoint.sh"]

