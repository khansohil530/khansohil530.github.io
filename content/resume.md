---
title: "Resume"
showDate: false
showViews: false
showLikes: false
showDateOnlyInArticle: false
showDateUpdated: false
showAuthor: true
showEdit: false
showReadingTime: false
showRelatedContent: false
showWordCount: false
showComments: false
showZenMode: false
---

## 👨‍💻 Experience

{{< timeline >}}

  {{< timelineItem 
    icon="code" 
    header="Alphasense" 
    badge="Jan 2024 - Nov 2024" 
    subheader="Software Engineer 2">}} 
<ul>
<li>
<b style="color:#bef264">Box Integration</b>: Designed and developed a microservice to sync and ingest Box file content and metadata into
Alphasense using a single workspace account. Built a dual-variant microservice: a web server variant for registering
sync, associating metadata from Alphasense, and clearing synced data, and a processing variant with multithreaded
workers to queue and process sync tasks efficiently. Integrated Box Events API to enable delta sync for real-time
content and metadata updates. Optimized worker execution to enhance scalability and responsiveness.
</li>
<li>
<b style="color:#bef264">Token Encryption</b>: Enhanced security by migrating production client tokens to encrypted storage using a
vault-stored encryption key. Designed and executed a Python-based migration script integrated into scheduled
maintenance workflows.
</li>
</ul>
  {{< /timelineItem >}}
  {{< timelineItem 
    icon="code" 
    header="Alphasense" 
    badge="June 2022 - Jan 2024" 
    subheader="Software Engineer" >}}
<ul>
<li>
<b style="color:#bef264">Citadel Migration</b>: Built scalable ingestion scripts to transform and migrate data from product VPCs to private
VPCs. Implemented entity mapping via JSON configurations to standardize data across systems, allowing seamless
execution through a single bash script.
</li>
<li>
<b style="color:#bef264">Sentieo to Alphasense Migration</b>: Designed and developed a migration system enabling account managers to
sync Sentieo client data to Alphasense. Built a FastAPI backend that supports APIs for sync management, data
clearing, and reporting, with a Retool-based front end for intuitive control. Optimized scheduled sync scripts for
parallel execution, achieving high throughput and ensuring data integrity. Implemented daily migration reports to
track entity-level stats.
</li>
</ul>
  {{< /timelineItem >}}


  {{< timelineItem 
    icon="code" 
    header="Sentieo" 
    badge="Jan 2022 - Jun 2022" 
    subheader="Software Engineer Intern" >}}

  
  
  <b style="color:#bef264">Jupyterhub</b>: Developed an RBAC enabled interface to streamline daily operational tasks for customer success
managers reducing the dependency on developers. Automated client data ingestion and report extraction,
improving workflow efficiency.
  {{< /timelineItem >}}

{{< /timeline >}}


## 👨‍🎓 Education

{{< timeline >}}

  {{< timelineItem 
    icon="graduation-cap" 
    header="Birla Institute of Technology and Science, Pilani" 
    badge="Graduate" 
    subheader="Bachelor of Engineering in Electrical and Electronics" >}}
Aug 2017 – Jul 2022
  {{< /timelineItem >}}

   {{< timelineItem 
    icon="graduation-cap" 
    header="Birla Institute of Technology and Science, Pilani" 
    badge="Graduate" 
    subheader="Master of Science in Economics" >}} 
   Aug 2017 – Jul 2022
  {{< /timelineItem >}}

{{< /timeline >}}
