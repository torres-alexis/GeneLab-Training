FROM public.ecr.aws/smce/smce-images:smce-oss-earth-base-03544260

# Packages installed on top of the OSS Earth base image:
    # wget
    # bsdmainutils

    # bash_kernel==0.9.3
    # coreutils==9.5
    # r-base==4.4.2
    # r-irkernel==1.3.2
    # fastqc==0.12.1
    # multiqc==1.24.1

    # tidyverse==2.0.0 installed via R installation - Conda hosted tidyverse 2.0.0 installation failed on several systems 


USER root

# Install system utilities
RUN apt-get update && apt-get install -y \
    wget \
    bsdmainutils \
    && rm -rf /var/lib/apt/lists/*

# Download environment.yml to tmp, install packages, then clean up
COPY environment.yml /tmp/environment.yml
RUN mamba env update -n notebook -f /tmp/environment.yml && \
    rm /tmp/environment.yml && \
    mamba clean -a -y 

# Install additional R packages
RUN conda run -n notebook R -e "\
install.packages('tidyverse', dependencies = TRUE, repos='https://cran.rstudio.com/');"

USER jovyan