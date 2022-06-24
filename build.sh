#!/usr/bin/env bash
set -eux
temp_folder="/tmp/dci-doc"
rm -rf "${temp_folder}"
mkdir "${temp_folder}"
cp -r . "${temp_folder}"
projects="dci-control-server dci-ui python-dciclient python-dciauth dci-downloader dci-openstack-agent dci-rhel-agent dci-openshift-agent ansible-playbook-dci-beaker dci-openshift-app-agent dci-pipeline"
for project in ${projects}; do
    echo "${project}"
    mkdir "${temp_folder}/src/${project}"
    (tar c -C "../${project}" $(cd "../${project}"; find . -name "*.md"|grep -v "^\./\(\.\|node_modules\)")) | tar xv -C "${temp_folder}/src/${project}/"
done

pushd "${temp_folder}"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
mkdocs build
popd
rm -rf ./docs
mkdir ./docs
cp -r "${temp_folder}/docs/" ./
rm -rf "${temp_folder}"
