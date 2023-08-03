# Helm Chart for HCL Domino
A Helm chart for HCL Domino server. Unofficial.

## Overview

This [Helm](https://helm.sh/) chart installs [HCL Domino](https://www.hcltechsw.com/domino) V12+ in a [Kubernetes](https://kubernetes.io/) cluster.

The chart is unofficial; we created it for our *Domino on Kubernetes* workshops and seminars.


## Documentation

Read the instructions in the chart [README](charts/domino/README.md) file.


## Author
Petr Kunc, HCLSoftware


## Credits

The initial inspiration came from the work of [Daniel Nashed](https://github.com/Daniel-Nashed) and [Thomas Hampel](https://github.com/thampel).

The Helm chart uses a Domino container created by [_domino-container_](https://github.com/HCL-TECH-SOFTWARE/domino-container) community build script, maintained by Daniel Nashed.


## License

The Helm charts associated scripts and config files are licensed under the [Apache 2.0 license](/LICENSE).

License for the products that can be installed with the Helm charts (HCL Domino, HCL Domino Leap, HCL Verse, HCL Notes Traveler, ...) can be found here: [HCLSoftware License Agreements](https://www.hcl-software.com/resources/license-agreements).

Note that HCL Domino and add-on products are commercial software – The software licenses agreement does not permit further distribution of the docker image that was built using this script.


## Disclaimer

This product is not officially supported and can be used as-is. This product is only a proof of concept, and the author would welcome any feedback. The author does not make any warranty about the completeness, reliability, and accuracy of this code. Any action you take by using this code is strictly at your own risk, and the author will not be liable for any losses and damages in connection with the use of this code.