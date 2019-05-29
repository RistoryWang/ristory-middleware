# ristory-middleware
# efk
基于(V7.1.0)elasticsearch+filebeat+kibana
收集全量日志,便于回溯分析

# tig
基于最新版(2019-05-29)telegraf+influxdb+grafana
用于基础资源告警和部分业务告警，结合钉钉和邮件通知

# sentry
基于sentry+redis+memcached+postgresql
用于收集WARN以上级别日志，结合钉钉和邮件通知实时告警
修改sentry源码，实现自定义告警级别匹配