# openshift-network-host-perf

### Description

Runs network tests on an Openshift cluster nodes to determine network issues.  The following flow occurs:
- oc debug to each host and run:
  - curl to Openshift master API URL and display time results
  - curl to Openshift console URL and display time results
  - ping all other nodes in cluster and display results
  - ping 8.8.8.8 and display results

Note: `oc debug node` is used which uses the host network of each node.


### Prerequisites

Must run in a bash shell and have `oc` present


### Usage

- First get the admin kube config:
```ibmcloud ks cluster config -c <cluster-name> --admin```

- In the same shell, run the following bash script
```./runtest.sh```
 
