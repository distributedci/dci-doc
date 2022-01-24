#!/usr/bin/env bash
set -eux
temp_folder="/tmp/dci-doc"
rm -rf ${temp_folder}
mkdir ${temp_folder}
cp -r . ${temp_folder}
projects="dci-control-server dci-ui python-dciclient python-dciauth dci-downloader dci-openstack-agent dci-rhel-agent dci-openshift-agent ansible-playbook-dci-beaker dci-openshift-app-agent"
for project in ${projects}
do
    echo ${project}
    rm -rf ${temp_folder}/docs/${project}
    mkdir ${temp_folder}/docs/${project}
    cp ../${project}/README* ${temp_folder}/docs/${project}/
    cp -r ../${project}/docs/ ${temp_folder}/docs/${project}/docs/ 2>/dev/null || true
done
pushd ${temp_folder}
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
mkdocs build
popd
rm -rf ./site
mkdir ./site
cp -r ${temp_folder}/site/* ./site/
rm -rf ${temp_folder}
