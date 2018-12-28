
# ψᵟ
#
#
# Based on base-notebook from Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#
FROM continuumio/miniconda3

RUN  useradd -m -s /bin/bash -N -g sudo "marcvs" \
  && printf "tcho\ntcho" |passwd marcvs

ENV DEBIAN_FRONTEND noninteractive

RUN   apt-get update \
   && apt-get install -yq --no-install-recommends \
      wget \
      bzip2 \
      tree \
      ca-certificates \
      sudo \
      locales \
      fonts-liberation \
      libgtk2.0-dev \
      # aptitude \
      pdf2svg \
      fonts-dejavu \
      tzdata \
      gfortran \
      gcc \
      octave \
      gnupg gnupg2 gnupg1 \
   && rm -rf /var/lib/apt/lists/*
#


RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# get node
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
 && apt-get install -y nodejs --no-install-recommends \
 && echo "node:"; node -v; echo "npm:"; npm -v \
 && npm i -g npm \
 && echo "node:"; node -v; echo "npm:"; npm -v; sleep 30s


# Configure environment
ENV SHELL=/bin/bash \
    # NB_USER=jovyan \
    # # NB_UID=$NB_UID \
    # NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


#__________________________________________


#____julia ________________________________
ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH

WORKDIR $JULIA_PATH

RUN   curl -fL -o julia.tar.gz "https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz"; \
      tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	    rm julia.tar.gz;

RUN  julia -e 'import Pkg; Pkg.add("Libdl")' \
  # && julia -e 'import Pkg; Pkg.add("PyPlot")' \
  # && julia -e 'import Pkg; Pkg.add("PGFPlots")' \
  # && julia -e 'import Pkg; Pkg.add("Plots")' \
  # && julia -e 'import Pkg; Pkg.add("PlotlyJS")' \
  # && julia -e 'import Pkg; Pkg.add("UnicodePlots")' \
  && julia -e 'import Pkg; Pkg.add("RDatasets")' \
  && julia -e 'import Pkg; Pkg.add("Unitful")' \
  && julia -e 'import Pkg; Pkg.add("Feather")' \
  && julia -e 'import Pkg; Pkg.add("DataFrames")' \
  && julia -e 'import Pkg; Pkg.add("NamedArrays")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("Unitful")' \
  # && julia -e 'import Pkg; Pkg.add("HDF5")' \
  # && julia -e 'import Pkg; Pkg.add("GR")' \
  && julia -e 'import Pkg; Pkg.add("IJulia")' \
  && julia -e 'using IJulia'



#____r ____________________________________
# RUN conda update conda \
RUN conda install --quiet --yes \
    # 'rpy2=2.8*' \
    # 'r-base=3.4.1' \
    # 'r-irkernel=0.8*' \
    # 'r-plyr=1.8*' \
    # 'r-devtools=1.13*' \
    # 'r-tidyverse=1.1*' \
    # 'r-shiny=1.0*' \
    # 'r-rmarkdown=1.8*' \
    # 'r-forecast=8.2*' \
    # 'r-rsqlite=2.0*' \
    # 'r-reshape2=1.4*' \
    # 'r-nycflights13=0.2*' \
    # 'r-caret=6.0*' \
    # 'r-rcurl=1.95*' \
    # 'r-crayon=1.3*' \
    # 'r-randomforest=4.6*' \
    # 'r-htmltools=0.3*' \
    # 'r-sparklyr=0.7*' \
    # 'r-htmlwidgets=1.0*' \
    'r::r-essentials' \
    'r::r-feather' \
    'conda-forge::feather-format' \
    # 'r-htmlwidgets=1.0*' \
    # 'r-hexbin=1.27*' \
 && conda clean -tipsy
#

#____Octave _______________________________
RUN octave --eval 'pkg install -forge dataframe' \
 && pip install octave_kernel




#____OpenModelica _________________________
RUN for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` nightly"; done | tee /etc/apt/sources.list.d/openmodelica.list
RUN wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | apt-key add -
# To verify that your key is installed correctly
RUN apt-key fingerprint
# Gives output:
# pub   2048R/64970947 2010-06-22
#      Key fingerprint = D229 AF1C E5AE D74E 5F59  DF30 3A59 B536 6497 0947
# uid                  OpenModelica Build System

# Then update and install OpenModelica

# Update index (again)
RUN apt-get update && install -y omc omlib-modelica-3.2.2

# Install Python components
RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y git

# Install Jupyter notebook, always upgrade pip
# RUN pip install --upgrade pip
# RUN pip install jupyter jupyterlab

# Install OMPython and jupyter-openmodelica kernel
RUN pip install -U git+git://github.com/OpenModelica/OMPython.git
RUN pip install -U git+git://github.com/OpenModelica/jupyter-openmodelica.git

# Create a user profile "openmodelicausers" inside the docker container as we should run the docker container as non-root users
# RUN useradd -m -s /bin/bash openmodelicausers
RUN useradd -m -s /bin/bash jovyan

# Copy the kernel from root location to non root location so that jupyter notebook when started as non-root can find openmodelica kernel
RUN cp -R /root/.local/share/jupyter/kernels/OpenModelica /usr/local/share/jupyter/kernels/

# Change the container to non-root "openmodelicauser" and set the env
USER openmodelicausers
ENV HOME /home/openmodelicausers
ENV USER openmodelicausers
WORKDIR $HOME




#____SoS __________________________________
RUN   pip install --upgrade pip \
   && pip install jupyter -U \
                  jupyterlab \
                  sos \
                  sos-notebook \
                  sos-bash \
									bash_kernel \
									markdown_kernel \
                  # sos-javascript \
                  sos-julia \
                  sos-matlab \
                  sos-python \
                  sos-r \
   && python -m sos_notebook.install \
	 && python -m bash_kernel.install \
	 && python -m markdown_kernel.install \
   && jupyter labextension install jupyterlab-sos

#

#____javascript/typescript ________________
# RUN npm install ijavascript \
#  && npm install typescript \
#  && npm install itypescript \
#  && ijsinstall; \
#     its --ts-install=local



WORKDIR /user/jovyan

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
