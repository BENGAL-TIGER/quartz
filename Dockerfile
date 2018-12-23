
# ψᵟ
#
#
# Based on base-notebook from Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#
FROM continuumio/miniconda3

# RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     locale-gen
RUN  useradd -m -s /bin/bash -N -g sudo "marcvs" \
  && printf "tcho\ntcho" |passwd marcvs

ENV DEBIAN_FRONTEND noninteractive

RUN   apt-get update \
   && apt-get install -yq --no-install-recommends \
      wget \
      bzip2 \
      ca-certificates \
      sudo \
      locales \
      fonts-liberation \
      libgtk2.0-dev \
      aptitude \
      pdf2svg \
      fonts-dejavu \
      tzdata \
      gfortran \
      gcc \
   && rm -rf /var/lib/apt/lists/*


# Configure environment
ENV SHELL=/bin/bash \
    # NB_USER=jovyan \
    # # NB_UID=$NB_UID \
    # NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH


#____julia ________________________________
WORKDIR $JULIA_PATH

RUN   curl -fL -o julia.tar.gz "https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz"; \
      tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	    rm julia.tar.gz;

RUN  julia -e 'import Pkg; Pkg.add("Libdl")' \
  && julia -e 'import Pkg; Pkg.add("PyPlot")' \
  && julia -e 'import Pkg; Pkg.add("PGFPlots")' \
  && julia -e 'import Pkg; Pkg.add("Plots")' \
  && julia -e 'import Pkg; Pkg.add("PlotlyJS")' \
  && julia -e 'import Pkg; Pkg.add("UnicodePlots")' \
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
  && julia -e 'import Pkg; Pkg.add("GR")' \
  && julia -e 'import Pkg; Pkg.add("IJulia")' \
  && julia -e 'using IJulia'



#____r ____________________________________
RUN conda update conda \
 && conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.1*' \
    'r-shiny=1.0*' \
    'r-rmarkdown=1.8*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.7*' \
    'r-htmlwidgets=1.0*' \
    'r::r-essentials' \
    'r::r-feather' \
    'conda-forge::feather-format' \
    # 'r-htmlwidgets=1.0*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy
#

#____Octave _______________________________
RUN apt-get update && \
    apt-get install octave \
 && rm -rf /var/lib/apt/lists/* \
 && octave --eval 'pkg install -forge dataframe' \
 && pip install octave_kernel

#____SoS __________________________________
RUN   pip install --upgrade pip \
   && pip install jupyter -U \
                  jupyterlab \
                  sos \
                  sos-notebook \
                  sos-bash \
                  sos-javascript \
                  sos-julia \
                  sos-matlab \
                  sos-python \
                  sos-r \
               && python -m sos_notebook.install \
               && jupyter labextension install jupyterlab-sos


WORKDIR /docs

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
