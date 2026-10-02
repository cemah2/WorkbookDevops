#!/usr/bin/env python3
"""Génère certifs/<CODE>/programme.md au format uniforme (front matter + IDs stables)."""
import re, pathlib, textwrap

SRC = pathlib.Path(__file__).parent / "certs/programmes-certifications"
OUT = pathlib.Path(__file__).parent / "out/certifs"
RETRIEVED = "2026-09-28"
CONVERTED = "2026-10-02"
CNCF_REPO = "https://github.com/cncf/curriculum"

# --------------------------------------------------------------------------
# Programmes CNCF, retranscrits depuis les PDF officiels (page 2, lus visuellement)
# (poids, domaine, [compétences])
# --------------------------------------------------------------------------
CNCF = {
 "KCNA": dict(title="Kubernetes and Cloud Native Associate", file="KCNA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (44,"Kubernetes Fundamentals",["Kubernetes Core Concepts","Administration","Scheduling","Containerization"]),
  (28,"Container Orchestration",["Networking","Security","Troubleshooting","Storage"]),
  (16,"Cloud Native Application Delivery",["Application Delivery","Debugging"]),
  (12,"Cloud Native Architecture",["Observability","Cloud Native Ecosystem and Principles","Cloud Native Community and Collaboration"]),
 ]),
 "KCSA": dict(title="Kubernetes and Cloud Native Security Associate", file="KCSA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (14,"Overview of Cloud Native Security",["The 4Cs of Cloud Native Security","Cloud Provider and Infrastructure Security","Controls and Frameworks","Isolation Techniques","Artifact Repository and Image Security","Workload and Application Code Security"]),
  (22,"Kubernetes Cluster Component Security",["API Server","Controller Manager","Scheduler","Kubelet","Container Runtime","KubeProxy","Pod","Etcd","Container Networking","Client Security","Storage"]),
  (22,"Kubernetes Security Fundamentals",["Pod Security Standards","Pod Security Admissions","Authentication","Secrets","Isolation and Segmentation","Audit Logging","Network Policy"]),
  (16,"Kubernetes Threat Model",["Kubernetes Trust Boundaries and Data Flow","Persistence","Denial of Service","Malicious Code Execution and Compromised Applications in Containers","Attacker on the Network","Access to Sensitive Data","Privilege Escalation"]),
  (16,"Platform Security",["Supply Chain Security","Image Repository","Observability","Service Mesh","PKI","Connectivity","Admission Control"]),
  (10,"Compliance and Security Frameworks",["Compliance Frameworks","Threat Modeling Frameworks","Supply Chain Compliance","Automation and Tooling"]),
 ]),
 "CKA": dict(title="Certified Kubernetes Administrator", file="CKA_v1.35.pdf", version="Kubernetes 1.35",
  exam="pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée", golden=True, domains=[
  (10,"Storage",["Implement storage classes and dynamic volume provisioning","Configure volume types, access modes and reclaim policies","Manage persistent volumes and persistent volume claims"]),
  (15,"Workloads and Scheduling",["Understand application deployments and how to perform rolling update and rollbacks","Use ConfigMaps and Secrets to configure applications","Configure workload autoscaling","Understand the primitives used to create robust, self-healing, application deployments","Configure Pod admission and scheduling (limits, node affinity, etc.)"]),
  (20,"Servicing and Networking",["Understand connectivity between Pods","Define and enforce Network Policies","Use ClusterIP, NodePort, LoadBalancer service types and endpoints","Use the Gateway API to manage Ingress traffic","Know how to use Ingress controllers and Ingress resources","Understand and use CoreDNS"]),
  (30,"Troubleshooting",["Troubleshoot clusters and nodes","Troubleshoot cluster components","Monitor cluster and application resource usage","Manage and evaluate container output streams","Troubleshoot services and networking"]),
  (25,"Cluster Architecture, Installation and Configuration",["Manage role based access control (RBAC)","Prepare underlying infrastructure for installing a Kubernetes cluster","Create and manage Kubernetes clusters using kubeadm","Manage the lifecycle of Kubernetes clusters","Implement and configure a highly-available control plane","Use Helm and Kustomize to install cluster components","Understand extension interfaces (CNI, CSI, CRI, etc.)","Understand CRDs, install and configure operators"]),
 ]),
 "CKAD": dict(title="Certified Kubernetes Application Developer", file="CKAD_v1.35.pdf", version="Kubernetes 1.35",
  exam="pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée", golden=True, domains=[
  (20,"Application Design and Build",["Define, build and modify container images","Choose and use the right workload resource (Deployment, DaemonSet, CronJob, etc.)","Understand multi-container Pod design patterns (e.g. sidecar, init and others)","Utilize persistent and ephemeral volumes"]),
  (20,"Application Deployment",["Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)","Understand Deployments and how to perform rolling updates","Use the Helm package manager to deploy existing packages","Kustomize"]),
  (15,"Application Observability and Maintenance",["Understand API deprecations","Implement probes and health checks","Use built-in CLI tools to monitor Kubernetes applications","Utilize container logs","Debugging in Kubernetes"]),
  (25,"Application Environment, Configuration and Security",["Discover and use resources that extend Kubernetes (CRD, Operators)","Understand authentication, authorization and admission control","Understand requests, limits, quotas","Define resource requirements","Understand ConfigMaps","Create & consume Secrets","Understand ServiceAccounts","Understand Application Security (SecurityContexts, Capabilities, etc.)"]),
  (20,"Services and Networking",["Demonstrate basic understanding of NetworkPolicies","Provide and troubleshoot access to applications via services","Use Ingress rules to expose applications"]),
 ]),
 "CKS": dict(title="Certified Kubernetes Security Specialist", file="CKS_v1.34.pdf", version="Kubernetes 1.34 (⚠️ vérifier la version en vigueur avant ce jalon)",
  exam="pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée ; prérequis : CKA valide", golden=True, domains=[
  (15,"Cluster Setup",["Use Network security policies to restrict cluster level access","Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi)","Properly set up Ingress objects with TLS","Protect node metadata and endpoints","Verify platform binaries before deploying"]),
  (15,"Cluster Hardening",["Use Role Based Access Controls to minimize exposure","Exercise caution in using service accounts e.g. disable defaults, minimize permissions on newly created ones","Restrict access to Kubernetes API","Upgrade Kubernetes to avoid vulnerabilities"]),
  (10,"System Hardening",["Minimize host OS footprint (reduce attack surface)","Using least-privilege identity and access management","Minimize external access to the network","Appropriately use kernel hardening tools such as AppArmor, seccomp"]),
  (20,"Minimize Microservice Vulnerabilities",["Use appropriate pod security standards","Manage kubernetes secrets","Understand and implement isolation techniques (multi-tenancy, sandboxed containers, etc.)","Implement Pod-to-Pod encryption (Cilium, Istio)"]),
  (20,"Supply Chain Security",["Minimize base image footprint","Understand your supply chain (e.g. SBOM, CI/CD, artifact repositories)","Secure your supply chain (permitted registries, sign and validate artifacts, etc.)","Perform static analysis of user workloads and container images (e.g. Kubesec, KubeLinter)"]),
  (20,"Monitoring, Logging and Runtime Security",["Perform behavioral analytics to detect malicious activities","Detect threats within physical infrastructure, apps, networks, data, users and workloads","Investigate and identify phases of attack and bad actors within the environment","Ensure immutability of containers at runtime","Use Kubernetes audit logs to monitor access"]),
 ]),
 "PCA": dict(title="Prometheus Certified Associate", file="PCA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (28,"PromQL",["Selecting Data","Rates and Derivatives","Aggregating over time","Aggregating over dimensions","Binary operators","Histograms","Timestamp Metrics"]),
  (20,"Prometheus Fundamentals",["System Architecture","Configuration and Scraping","Understanding Prometheus Limitations","Data Model and Labels","Exposition Format"]),
  (18,"Observability Concepts",["Metrics","Understand logs and events","Tracing and Spans","Push vs Pull","Service Discovery","Basics of SLOs, SLAs, and SLIs"]),
  (18,"Alerting & Dashboarding",["Dashboarding basics","Configuring Alerting rules","Understand and Use Alertmanager","Alerting basics (when, what, and why)"]),
  (16,"Instrumentation and Exporters",["Client Libraries","Instrumentation","Exporters","Structuring and naming metrics"]),
 ]),
 "OTCA": dict(title="OpenTelemetry Certified Associate", file="OTCA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (18,"Fundamentals of Observability",["Telemetry Data","Semantic Conventions","Instrumentation","Analysis and Outcomes"]),
  (46,"The OpenTelemetry API and SDK",["Data Model","Composability and Extension","Configuration","Signals (Tracing, Metric, Log)","SDK Pipelines","Context Propagation","Agents"]),
  (26,"The OpenTelemetry Collector",["Configuration","Deployment","Scaling","Pipelines","Transforming Data"]),
  (10,"Maintaining and Debugging Observability Pipelines",["Context Propagation","Debugging Pipelines","Error Handling","Schema Management"]),
 ]),
 "CGOA": dict(title="Certified GitOps Associate", file="CGOA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (20,"GitOps Terminology",["Continuous","Declarative Description","Desired State","State Drift","State Reconciliation","GitOps Managed Software System","State Store","Feedback Loop","Rollback"]),
  (30,"GitOps Principles",["Declarative","Versioned and Immutable","Pulled Automatically","Continuously Reconciled"]),
  (16,"Related Practices",["Configuration as Code (CaC)","Infrastructure as Code (IaC)","DevOps and DevSecOps","CI and CD"]),
  (20,"GitOps Patterns",["Deployment and Release Patterns","Progressive Delivery Patterns","Pull vs. Event-driven","Architecture patterns (in-cluster and external reconciler, state store management, etc.)"]),
  (14,"Tooling",["Manifest Format and Packaging","State Store Systems (Git and alternatives)","Reconciliation Engines (ArgoCD, Flux, and alternatives)","Interoperability with Notifications, Observability, and Continuous Integration Tools"]),
 ]),
 "CAPA": dict(title="Certified Argo Project Associate", file="CAPA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (36,"Argo Workflows",["Understand Argo Workflow Fundamentals","Generating and Consuming Artifacts","Understand Argo Workflow Templates","Understand the Argo Workflow Spec","Work with DAG (Directed-Acyclic Graphs)","Run Data Processing Jobs with Argo Workflows"]),
  (34,"Argo CD",["Understand Argo CD Fundamentals","Synchronize Applications Using Argo CD","Use Argo CD Application","Configure Argo CD with Helm and Kustomize","Identify Common Reconciliation Patterns"]),
  (18,"Argo Rollouts",["Understand Argo Rollouts Fundamentals","Use Common Progressive Rollout Strategies","Describe Analysis Template and AnalysisRun"]),
  (12,"Argo Events",["Understand Argo Events Fundamentals","Understand Argo Event Components and Architecture"]),
 ]),
 "CCA": dict(title="Cilium Certified Associate", file="CCA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (20,"Architecture",["Understand the Role of Cilium in Kubernetes Environments","Cilium Architecture","IP Address Management (IPAM) with Cilium","Cilium Component Roles","Datapath Models"]),
  (18,"Network Policy",["Interpret Cilium Network Policies and Intent","Understand Cilium's Identity-based Network Security Model","Policy Enforcement Modes","Policy Rule Structure","Kubernetes Network Policies versus Cilium Network Policies"]),
  (16,"Service Mesh",["Know How to use Ingress or Gateway API for Ingress Routing","Service Mesh Use Cases","Understand the Benefits of Gateway API over Ingress","Encrypting Traffic in Transit with Cilium","Sidecar-based versus Sidecarless Architectures"]),
  (10,"Network Observability",["Understand the Observability Capabilities of Hubble","Enabling Layer 7 Protocol Visibility","Know How to Use Hubble from the Command Line or the Hubble UI"]),
  (10,"Installation and Configuration",["Know How to Use Cilium CLI to Query and Modify the Configuration","Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status"]),
  (10,"Cluster Mesh",["Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity","Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh"]),
  (10,"eBPF",["Understand the Role of eBPF in Cilium","eBPF Key Benefits","eBPF-based Platforms versus IPtables-based Platforms"]),
  (6,"BGP and External Networking",["Egress Connectivity Requirements","Understand Options to Connect Cilium-managed Clusters with External Networks"]),
 ]),
 "ICA": dict(title="Istio Certified Associate", file="ICA.pdf", version=None,
  exam="pratique (terminal), 120 min, en ligne surveillé", golden=True, domains=[
  (20,"Installation, Upgrades, and Configuration",["Installing Istio with istioctl or Helm","Installing Istio in Sidecar or Ambient Mode","Customizing your Istio Installation","Upgrading Istio (Canary, In-Place)"]),
  (35,"Traffic Management",["Configuring Ingress and Egress Traffic","Configuring Routing within a Service Mesh","Defining Traffic Policies with Destination Rules","Configuring Traffic Shifting","Connecting In-Mesh Workloads to External Workloads and Services","Using Resilience Features (circuit breaking, failover, outlier detection, timeouts, retries)","Using Fault Injection"]),
  (25,"Securing Workloads",["Configuring Authorization","Configuring Authentication (mTLS, JWT)","Securing Edge Traffic with TLS"]),
  (20,"Troubleshooting",["Troubleshooting Configuration","Troubleshooting the Mesh Control Plane","Troubleshooting the Mesh Data Plane"]),
 ]),
 "KCA": dict(title="Kyverno Certified Associate", file="KCA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (18,"Fundamentals of Kyverno",["Kyverno Policies & Rules","YAML Manifests","Admission Controllers","OCI Images"]),
  (18,"Installation, Configuration, and Upgrades",["Helm-based Installation and Configuration","Kyverno Custom Resource Definitions (CRDs)","Controller Configuration with Flags","Configuring Kyverno RBAC, roles, and permissions","High Availability Installations","Upgrading Kyverno"]),
  (12,"Kyverno CLI",["apply","test","jp","Installing Kyverno CLI"]),
  (10,"Applying Policies",["Applying Policy in Cluster","Resource Selection","Common Policy Settings for Kyverno Rules"]),
  (32,"Writing Policies",["Validation Rules","Preconditions","Background Scans","Mutation Rules","Generation Rules","VerifyImage Rules","Variables & API Calls in Policies","JSON Patches","Autogen Rules","Cleanup Policies","Common Expression Language (CEL)"]),
  (10,"Policy Management",["Policy Reports","PolicyExceptions","Kyverno Metrics"]),
 ]),
 "CBA": dict(title="Certified Backstage Associate", file="CBA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (24,"Backstage Development Workflow",["Build and run Backstage projects locally","Understand local development workflows","Compile a Backstage project with TypeScript","Download and install dependencies for a Backstage project with NPM/Yarn","Use Docker to build a container image of a Backstage project"]),
  (22,"Backstage Catalog",["Understand how/why to use Backstage Catalog","Populate Backstage Catalog","Using annotations","Working with manually registered entity locations","Troubleshooting entity ingestion","Working with automated ingestion"]),
  (22,"Backstage Infrastructure",["Understand the Backstage framework","Configure Backstage","Deploy Backstage to production","Understand Backstage client-server architecture"]),
  (32,"Customizing Backstage",["Understand frontend versus backend plugins","Customizing Backstage plugins","Make changes to React code in Backstage App","Using Material UI components"]),
 ]),
 "CNPA": dict(title="Certified Cloud Native Platform Engineering Associate", file="CNPA.pdf", version=None,
  exam="QCM, 90 min, en ligne surveillé", golden=True, domains=[
  (36,"Platform Engineering Core Fundamentals",["Declarative Resource Management","DevOps Practices in Platform Engineering","Application Environments and Infrastructure Concepts","Platform Architecture and Capabilities","Platform Engineering Goals, Objectives, and Approaches","Continuous Integration Fundamentals","Continuous Delivery and GitOps"]),
  (20,"Platform Observability, Security, and Conformance",["Observability Fundamentals: Traces, Metrics, Logs, and Events","Secure Service Communication","Policy Engines for Platform Governance","Kubernetes Security Essentials","Security in CI/CD Pipelines"]),
  (16,"Continuous Delivery & Platform Engineering",["Continuous Integration Pipelines Overview","Incident Response in Platform Engineering","CI/CD Relationship Fundamentals","GitOps Basics and Workflows","GitOps for Application Environments"]),
  (12,"Platform APIs and Provisioning Infrastructure",["Kubernetes Reconciliation Loop","APIs for Self-Service Platforms (CRDs)","Infrastructure Provisioning with Kubernetes","Kubernetes Operator Pattern for Integration"]),
  (8,"IDPs and Developer Experience",["Simplified Access to Platform Capabilities","API-Driven Service Catalogs","Developer Portals for Platform Adoption","AI/ML in Platform Automation"]),
  (8,"Measuring your Platform",["Platform Efficiency and Team Productivity","DORA Metrics for Platform Initiatives"]),
 ]),
 "CNPE": dict(title="Certified Cloud Native Platform Engineer", file="CNPE.pdf", version=None,
  exam="pratique (terminal), 120 min, en ligne surveillé", golden=True, domains=[
  (15,"Platform Architecture and Infrastructure",["Applying Platform Architecture Best Practices for Networking, Storage, and Compute","Using Cost Management Solutions for Right-Sizing and Scaling","Optimizing Multi-Tenancy Resource Usage"]),
  (25,"GitOps and Continuous Delivery",["Implementing GitOps Workflows for Application and Infrastructure Deployment","Building and Configuring CI/CD Pipelines Integrated with Kubernetes","Deploying Applications Using Progressive Delivery Strategies (e.g., Blue/Green or Canary)"]),
  (25,"Platform APIs and Self-Service Capabilities",["Designing and Creating Custom Resource Definitions (CRDs) for Platform Services","Implementing Workflows for Self-Service Provisioning Using Platform APIs","Using Kubernetes Operators for Platform Automation and Integration","Using Automation Frameworks for Self-Service Provisioning"]),
  (20,"Observability and Operations",["Implementing Monitoring, Alerting, Logging, and Tracing Solutions","Measuring and Improving Platform Efficiency Using Deployment Metrics and Performance Indicators","Diagnosing and Remediating Platform Issue and Incident Scenarios"]),
  (15,"Security and Policy Enforcement",["Configuring Secure Service-to-Service Communication","Applying RBAC and Security Controls Across Platform Resources","Generating Audit Trails and Enforcing Policy Compliance (SBOM, Compliance Reports, etc.)","Using Policy Engines and Admission Controllers for Governance","Integrating Security Scanning and Compliance Checks into Deployment Pipelines"]),
  ],
  extra="""## Outils cités par le programme (page 3 du PDF)

Le candidat doit savoir accomplir des tâches avec des outils qu'il ne connaît pas, en s'appuyant sur la documentation disponible pendant l'examen. Les projets ci-dessous sont donnés par la CNCF comme exemples de ce qui peut apparaître ; il n'y a pas de question sur les détails internes d'un outil s'il n'est pas cité dans les compétences.

Argo · Crossplane · Flagger · Flux · Gatekeeper · Grafana · Istio · Jaeger · Kyverno · Linkerd · OPA · OpenCost · OpenTelemetry · Prometheus · Tekton
"""),
}

# --------------------------------------------------------------------------
# Autres éditeurs : (fichier source, code, émetteur, titre, version, exam, licence, golden)
# --------------------------------------------------------------------------
OTHERS = {
 "LFCS": dict(src="LFCS.md", issuer="The Linux Foundation", title="Linux Foundation Certified System Administrator",
   version="distribution non imposée (vérifier le handbook)", exam="pratique (terminal), 120 min, en ligne surveillé", golden=True,
   url="https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/"),
 "RHCSA": dict(src="RHCSA_EX200.md", issuer="Red Hat", title="Red Hat Certified System Administrator (EX200)",
   version="Red Hat Enterprise Linux 10", exam="pratique, sur machine, ~3 h, en centre ou à distance", golden=False,
   url="https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam"),
 "RHCE": dict(src="RHCE_EX294.md", issuer="Red Hat", title="Red Hat Certified Engineer (EX294)",
   version="RHEL 9 + Ansible Automation Platform (⚠️ version RHEL 10 annoncée, à vérifier)", exam="pratique, sur machine, ~4 h, en centre ou à distance ; prérequis : RHCSA", golden=False,
   url="https://www.redhat.com/en/services/training/ex294-red-hat-certified-engineer-rhce-exam-red-hat-enterprise-linux"),
 "TFA": dict(src="Terraform_Associate_004.md", issuer="HashiCorp", title="HashiCorp Certified: Terraform Associate (004)",
   version="Terraform 1.12", exam="QCM / vrai-faux, 60 min, en ligne surveillé ; pas de pondération officielle", golden=False,
   url="https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004"),
 "VA": dict(src="Vault_Associate_003.md", issuer="HashiCorp", title="HashiCorp Certified: Vault Associate (003)",
   version="Vault 1.16.x", exam="QCM / vrai-faux, 60 min, en ligne surveillé ; pas de pondération officielle", golden=False,
   url="https://developer.hashicorp.com/vault/tutorials/associate-cert-003/associate-review-003"),
 "COA": dict(src="COA_OpenStack.md", issuer="OpenInfra Foundation", title="Certified OpenStack Administrator",
   version="OpenStack 2026.1 Gazpacho (⚠️ à confirmer dans le handbook)", exam="pratique (terminal), 180 min, en ligne surveillé", golden=False,
   url="https://www.openstack.org/coa/requirements"),
}

def slug(s):  # pour les ancres
    return re.sub(r"[^a-z0-9]+","-",s.lower()).strip("-")

def front(code, d, issuer, source_url, source_file, license_, weighted):
    v = d.get("version") or "non versionné"
    return textwrap.dedent(f"""\
    ---
    code: {code}
    title: "{d['title']}"
    issuer: "{issuer}"
    version: "{v}"
    exam_format: "{d['exam']}"
    weighted_domains: {str(weighted).lower()}
    golden_kubestronaut: {str(d.get('golden', False)).lower()}
    source_url: "{source_url}"
    source_file: "{source_file}"
    license: "{license_}"
    retrieved: {RETRIEVED}
    converted: {CONVERTED}
    status: "à revérifier lors de la veille (voir LISEZMOI)"
    ---
    """)

def body(code, title, domains, weighted, notes, extra):
    out = [f"# {code} — {title}\n"]
    out.append("Programme officiel retranscrit tel quel (en anglais). Les identifiants `"
               f"{code}-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).\n")
    if notes:
        out.append("## Notes\n")
        out += [f"- {n}" for n in notes] + [""]
    out.append("## Domaines\n")
    if weighted:
        out.append("| ID | Domaine | Poids |\n|---|---|---|")
        for i,(w,name,_) in enumerate(domains,1):
            out.append(f"| {code}-{i:02d} | [{name}](#{code.lower()}-{i:02d}--{slug(name)}) | {w} % |")
        total = sum(w for w,_,_ in domains)
        out.append(f"| | **Total** | **{total} %** |\n")
    else:
        out.append("| ID | Domaine |\n|---|---|")
        for i,(w,name,_) in enumerate(domains,1):
            out.append(f"| {code}-{i:02d} | [{name}](#{code.lower()}-{i:02d}--{slug(name)}) |")
        out.append("")
    out.append("## Compétences\n")
    for i,(w,name,items) in enumerate(domains,1):
        head = f"### {code}-{i:02d} — {name}" + (f" ({w} %)" if weighted else "")
        out.append(head + "\n")
        for j,it in enumerate(items,1):
            out.append(f"- **{code}-{i:02d}-{j:02d}** {it}")
        out.append("")
    if extra:
        out.append(extra)
    return "\n".join(out).rstrip() + "\n"

def write(code, text):
    p = OUT / code / "programme.md"
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text, encoding="utf-8")
    return p

# ---- CNCF
for code, d in CNCF.items():
    fm = front(code, d, "CNCF / The Linux Foundation", f"{CNCF_REPO} (dernier commit consulté : 2026-03-14)",
               d["file"], "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation", True)
    notes = []
    if code == "CKS":
        notes.append("Le dépôt CNCF était encore en 1.34 au 2026-09-28 alors que CKA/CKAD sont en 1.35 : vérifier la version de l'examen avant de figer le lab.")
    write(code, fm + "\n" + body(code, d["title"], d["domains"], True, notes, d.get("extra")))

# ---- Autres : parse des .md existants
def parse_md(path):
    meta, notes, domains, cur = [], [], [], None
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("## "):
            h = line[3:].strip()
            m = re.match(r"^(.*?)\s*[–-]\s*(\d+)\s*%$", h)
            if m: name, w = m.group(1).strip(), int(m.group(2))
            else: name, w = re.sub(r"^\d+\.\s*","",h), None
            cur = [w, name, []]; domains.append(cur)
        elif line.startswith("- "):
            item = line[2:].strip()
            if cur is None: meta.append(item)
            else:
                item = re.sub(r"^\d+[a-z]\.\s*","",item)  # retire « 1a. » (HashiCorp)
                cur[2].append(item)
        elif line.startswith(">"):
            notes.append(line.lstrip("> ").strip())
    return meta, notes, [tuple(d) for d in domains]

for code, d in OTHERS.items():
    meta, notes, domains = parse_md(SRC / "autres" / d["src"])
    weighted = all(w is not None for w,_,_ in domains)
    keep = [m for m in meta if not m.startswith(("Source", "Récupéré"))]
    fm = front(code, d, d["issuer"], d["url"], f"programmes-certifications/autres/{d['src']} (retranscription)",
               "Objectifs d'examen publics, retranscrits depuis la page officielle ; texte © éditeur, usage de référence", weighted)
    write(code, fm + "\n" + body(code, d["title"], domains, weighted, keep + notes, None))

# ---- index
rows = ["| Code | Certification | Émetteur | Version | Format | Golden Kubestronaut |","|---|---|---|---|---|---|"]
for code,d in list(CNCF.items()) + list(OTHERS.items()):
    issuer = "CNCF / LF" if code in CNCF else d["issuer"]
    rows.append(f"| [{code}]({code}/programme.md) | {d['title']} | {issuer} | {d.get('version') or '—'} | {d['exam'].split(',')[0]} | {'oui' if d.get('golden') else 'non'} |")
(OUT / "README.md").write_text(textwrap.dedent(f"""\
# Programmes officiels des certifications

Un dossier par certification, avec `programme.md` au format uniforme :
front matter (code, version, source, licence, dates), tableau des domaines pondérés,
puis une compétence par ligne avec un identifiant stable `CODE-DD-CC`
(DD = domaine, CC = compétence, dans l'ordre du document officiel).

Ces identifiants sont la clé du mapping objectifs → chapitres (`objectifs.md`, à générer)
et de la veille : un diff de `programme.md` montre exactement ce qui a changé entre deux versions.

## Conventions
- Le texte des compétences est **en anglais, tel quel** : c'est la formulation de l'examen.
- Une compétence supprimée par l'éditeur est conservée **barrée** avec la mention `(retiré vX)` pendant un cycle,
  pour ne pas casser les références ; un ajout prend le numéro suivant, jamais un numéro libéré.
- `status` reste « à revérifier » tant que la veille mensuelle n'a pas confirmé la version.

## Sources et licences
- CNCF : {CNCF_REPO} (PDF officiels, CC-BY 4.0), consultés le {RETRIEVED}.
- Red Hat, HashiCorp, OpenInfra, Linux Foundation (LFCS) : objectifs publics retranscrits depuis les pages officielles le {RETRIEVED}.
- Conversion en Markdown : {CONVERTED}.

## Golden Kubestronaut
KCNA, KCSA, CKA, CKAD, CKS, PCA, ICA, CCA, CAPA, CGOA, CBA, OTCA, KCA, CNPA, CNPE + LFCS, toutes valides simultanément.

## Points à vérifier avant chaque jalon
- CKS : programme en 1.34 dans le dépôt alors que CKA/CKAD sont en 1.35.
- RHCE EX294 : passage annoncé à RHEL 10.
- COA : version 2026.1 Gazpacho à confirmer dans le handbook.
- Durées, nombre de questions et validité : non reprises des PDF (absentes), à confirmer sur la page de chaque examen et à consigner dans `examen.md`.

## Index

{chr(10).join(rows)}
"""), encoding="utf-8")
print("OK", len(list(OUT.rglob("programme.md"))), "programmes")
