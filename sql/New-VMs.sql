--REPLICAS (new VMs vs current)

select *
from [dbo].[BObjects] bobjvar
INNER JOIN [dbo].[Backup.Model.ViCloudQuotaObjects] vi ON vi.object_id = bobjvar.id
INNER JOIN [dbo].[Backup.Model.ViHardwareQuotas] viq ON viq.id = vi.quota_id
INNER JOIN [dbo].[Tenants] ten ON ten.id = viq.tenantid
INNER JOIN [dbo].[Backup.Model.CloudLicensedObjects] clo ON clo.[object_id] = vi.[object_id]
where ten.name = '<tenantname>' 
AND ten.disabled = 0
AND DATEDIFF(dd, clo.last_processing_time, GETUTCDATE()) <= 31

select *
from [dbo].[BObjects] bobjvar
INNER JOIN [dbo].[Backup.Model.ViCloudQuotaObjects] vi ON vi.object_id = bobjvar.id
INNER JOIN [dbo].[Backup.Model.ViHardwareQuotas] viq ON viq.id = vi.quota_id
INNER JOIN [dbo].[Tenants] ten ON ten.id = viq.tenantid
INNER JOIN [dbo].[Backup.Model.CloudLicensedObjects] clo ON clo.[object_id] = vi.[object_id]
where ten.name = '<tenantname' 
AND ten.disabled = 0
AND (ten.expire_time > GETDATE() OR ten.expire_time IS NULL)
AND DATEDIFF(dd, clo.last_processing_time, GETUTCDATE()) > 31


--BACKUPS (new VMs vs current)

SELECT  t.name AS tenant_name, vms.vm_uuid, vms.creation_time, vms.last_processing_time
FROM    [dbo].[Backup.Model.CloudVmsOnQuotas] v
INNER JOIN [dbo].[Backup.Model.CloudVms] vms ON v.vm_id = vms.id
INNER JOIN [dbo].[TenantQuotaView] q ON v.resource_quota_id = q.id
INNER JOIN [dbo].[Tenants] t ON q.tenantId = t.id
WHERE t.disabled = 0
AND (t.expire_time > GETDATE() OR t.expire_time IS NULL)
AND DATEDIFF(dd, vms.last_processing_time, GETUTCDATE()) <= 31
AND t.name = '<tenantname>'

SELECT  t.name AS tenant_name, vms.vm_uuid, vms.creation_time, vms.last_processing_time
FROM    [dbo].[Backup.Model.CloudVmsOnQuotas] v
INNER JOIN [dbo].[Backup.Model.CloudVms] vms ON v.vm_id = vms.id
INNER JOIN [dbo].[TenantQuotaView] q ON v.resource_quota_id = q.id
INNER JOIN [dbo].[Tenants] t ON q.tenantId = t.id
WHERE t.disabled = 0
AND (t.expire_time > GETDATE() OR t.expire_time IS NULL)
AND DATEDIFF(dd, vms.last_processing_time, GETUTCDATE()) > 31
AND t.name = '<tenantname>'
