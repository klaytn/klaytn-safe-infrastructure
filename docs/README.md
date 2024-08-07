[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

# NO LONGER MAINTAINED

> [!IMPORTANT]
> Since the launch of Kaia Blockchain, this repository has been parked in favour of the new open-source projects in [Kaia's Github](https://github.com/kaiachain). Contributors have now moved there continuing with massive open-source contributions to our blockchain ecosystem. A big thank you to everyone who has contributed to this repository.
>
> For future development and contributions, please refer to the new [kaia-safe-infrastructure repository](https://github.com/kaiachain/kaia-safe-infrastructure)
>
> More information about Klaytn's chain merge with Finschia blockchain, please refer to the launching of Kaia blockchain [kaia.io](https://kaia.io).

---

# Klaytn Safe Infrastructure

**Klaytn Safe infrastructure diagram**
<figure><img src="./diagrams/safe-infrastructure-diagram.png" width="100%" alt="" /></figure>

- **Tx Service** is the core of the KlaytnSafe. It indexes multisig transactions, module transactions, token transfers, collects signatures... There must be **1 Tx Service per Chain**, with different workers, PostgreSQL, Redis and RabbitMQ.
- **Config Service** holds configuration for every Chain (blockexplorer, tx service url, apps enabled, wallets enabled...). **1 instance of the Config Service supports multiple Chains**
- **Client Gateway** provides an API optimized for clients (web ui, android, ios...). **1 instance of the Client Gateway supports multiple Chains**
- **Events Service** handles KlaytnSafe indexing events from Transaction Service and deliver as HTTP webhooks.

## Setup

This repository contains the minimum viable local setup for our backend services.
The setup presented here, assumes that only L2 safes will be used. Last stable version will be used for every service, but you can adjust them on `.env`, e.g.:

```bash
CFG_VERSION=v2.60.0
CGW_VERSION=v0.4.1
TXS_VERSION=v4.6.1
UI_VERSION=v1.2.0
EVENTS_VERSION=v0.5.0
```

You can change them to the version you are interested available in [docker-hub](https://hub.docker.com/u/safeglobal) but be aware that not all versions of our services are compatible with each other, so do so **at your own risk.**

- [Guide to run our services locally](running_locally.md)
- [Guide to run our services for production](running_production.md)
