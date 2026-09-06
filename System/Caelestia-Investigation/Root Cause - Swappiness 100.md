# Root Cause - Swappiness 100

## Overview
Swappiness set to 100 causing performance issues.

## Problem
vm.swappiness=100 causes excessive swap usage.

## Solution
Set swappiness to 10:
```bash
sudo sysctl vm.swappiness=10
```

## Tags
#swappiness #performance #linux
