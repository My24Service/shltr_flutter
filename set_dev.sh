#!/bin/bash

cd lib

rm -f app_config.dart
ln -s app_config_dev.dart app_config.dart

cd ..
