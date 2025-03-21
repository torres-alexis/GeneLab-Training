FROM public.ecr.aws/smce/smce-images:smce-oss-earth-base-03544260

# System dependencies
    # wget
    # bsdmainutils

# Conda dependencies
    # python==3.10
    # bash_kernel==0.9.3
    # coreutils==9.5
    # r-base==4.4.1
    # r-irkernel==1.3.2
    # fastqc==0.12.1
    # multiqc==1.24.1

# R dependencies (installed via R due to issues with updated conda package availability or installation)
    # tidyverse


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