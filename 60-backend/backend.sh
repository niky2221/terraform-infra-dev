#!/bin/bash

dnf install ansible -y
# push
# ansible-playbook -i inventory.ini backend.yaml

# pull
ansible-pull -i localhost, -U https://github.com/niky2221/Roles-ansible-expense-tf.git main.yaml -e COMPONENT=backend -e ENVIRONMENT=$1