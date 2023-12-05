FROM centos:7.5.1804

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y git unzip which gcc zip wget curl yum-utils docker-ce make openssl-devel bzip2-devel libffi-devel epel-release

RUN yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm \
	&& yum install zulu11-jdk -y \
	&& mv /lib/jvm/zulu11 /lib/jvm/zulu-11 \
	&& yum install -y libxcb
	
RUN mkdir -p /usr/java \
    && curl -u <secret:artifactory_user>:<secret:artifactory_api_key> -L https://artifactory.pmidce.com/artifactory/dce2-pmi-external/com/oracle/java/jdk/jdk-17.0.7_linux-x64/17.0.7/jdk-17.0.7_linux-x64.tar.gz -o /usr/java/jdk-17.0.7_linux-x64.tar.gz \
    && tar -zxf /usr/java/jdk-17.0.7_linux-x64.tar.gz -C /usr/java \
    && rm -f /usr/java/jdk-17.0.7_linux-x64.tar.gz \
    && mv /usr/java/jdk-17.0.7 /usr/java/jdk-17.0.7-amd64 \
    && ln -sf /usr/java/jdk-17.0.7-amd64/bin/java /usr/bin/java
	
	
RUN cd /opt && wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz \
    && tar xzf Python-3.8.0.tgz \
    && rm -rf Python-3.8.0.tgz \
    && cd Python-3.8.0 \
    && ./configure --enable-optimizations \
    && make altinstall  \
    && ln -s /usr/local/bin/python3.8 /usr/local/bin/python3 \
    && ln -s /usr/local/bin/pip3.8 /usr/local/bin/pip3

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -f awscliv2.zip   
	
RUN wget --no-check-certificate https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip \
    && unzip ./terraform_1.1.3_linux_amd64.zip -d /usr/local/bin/ \
    && rm -f terraform_1.1.3_linux_amd64.zip

RUN wget https://releases.hashicorp.com/packer/1.8.0/packer_1.8.0_linux_amd64.zip \
	&& unzip packer_1.8.0_linux_amd64.zip -d /usr/local/bin

RUN curl -LO https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.0-bin.zip \
	&& unzip apache-ant-1.10.0-bin.zip \
	&& mv apache-ant-1.10.0/ /opt/ant \
	&& ln -s /opt/ant/bin/ant /usr/bin/ant \
	&& rm -f apache-ant-1.10.0-bin.zip

RUN curl -LO https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip \
	&& unzip apache-maven-3.3.9-bin.zip \
	&& ln -sf /apache-maven-3.3.9/bin/mvn /usr/bin/mvn \
	&& rm -f apache-maven-3.3.9-bin.zip
	
RUN curl -s "https://get.sdkman.io" | bash \
    && . /root/.sdkman/bin/sdkman-init.sh \
    && sdk install groovy 2.5.4
