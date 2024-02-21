# py-project-template
template python repo for new projects

The python version we are working with is 3.10

## global step once for all projects

### Prerequisites:
* gcloud - https://cloud.google.com/sdk/install
* kubectl
~~~ bash
gcloud components install kubectl
~~~
* (potentially) Docker - https://docs.docker.com/install/

### Install poetry
https://python-poetry.org/docs/#installing-with-the-official-installer

### Setup poetry path
- $HOME/.local/bin on macOS
- %APPDATA%\Python\Scripts on Windows.

### add artifact registry keyring for poetry
without that you will not be authorized to artifact registry on 
poetry install
~~~ bash
$ poetry self add  keyrings.google-artifactregistry-auth
~~~

### authenticate gcp
~~~ bash
$ gcloud auth login
~~~
or (usually for windows)
~~~ bash
$ gcloud auth application-default login
~~~

### Setup GCP and K8S
~~~ bash
$ gcloud container clusters get-credentials infra-platform-v2 --region=europe-west1-b
$ kubectl config use-context gke_cytoreason_europe-west1-b_infra-platform-v2
~~~

## run setup.sh for specific installations
~~~ bash
$ ./setup.sh
~~~

## install dependencies
~~~ bash
$ poetry install
~~~

## Run Tests with coverage
~~~ bash
$ poetry run pytest --cov
~~~
## build package
~~~ bash
$ poetry build
~~~

## install package locally
~~~ bash
$ pip install -e /path/to/client
~~~


## publish package to artifact registry

install artifact registry keyring in poetry's venv:

~~~ bash
#  POETRY_PIP is:
#     ~/Library/Application Support/pypoetry/venv/bin/pip on MacOS.
#     ~/.local/share/pypoetry/venv/bin/pip on Linux/Unix.
#     %APPDATA%\pypoetry\venv\Scripts\pip on Windows.
#     $POETRY_HOME/venv/bin/pip if $POETRY_HOME is set.

$ $POETRY_PIP install keyrings.google-artifactregistry-auth
~~~
make sure you are logged in google (or have configured GOOGLE_APPLICATION_CREDENTIALS)

~~~ bash
$ gcloud auth login
$ # OR if you have a Service Account key file on disk:
$ export GOOGLE_APPLICATION_CREDENTIALS=creds/credentials.json
~~~

publish command (cytoreason-python-repo is referencing the artifact registry based python registry on .toml):

~~~ bash
$ poetry publish -r artifact-registry
~~~

## building docs with sphinx
~~~ bash
$ cd docs
$ make html
~~~
