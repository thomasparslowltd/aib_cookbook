#
# Cookbook Name:: aib_python
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info("aib_python:default My deploy stuff")

# Note that the recipe will install Python, setuptools and pip
include_recipe "python"
