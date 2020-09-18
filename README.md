# collectd plugins

## Data collecting plugins

### cpu

The CPU plugini collects the amount of time spent by the CPU in various
states, most notably executing user code, executing system code, waiting
for IO-operations and being idle.

    parameter_defaults:
        CollectdExtraPlugins:
          - cpu
        ExtraConfig:
            collectd::plugin::cpu::ReportByState: true

More options to be found at https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_cpu

### df

### interface

### disk

### virt

## Output plugins

### amqp1

the plugin writes values to an amqp1 message bus, such as qpid.

    parameter_defaults:
        CollectdExtraPlugins:
          - amqp1
        ExtraConfig:
            collectd::plugin::amqp1:

### write_http

The plugin writes data to an http endpoint.

    parameter_defaults:
        CollectdExtraPlugins:
          - write_http
        ExtraConfig:
            collectd::plugin::write_http::nodes:
                collectd:
                    url: collectd.tld.org
                    metrics: true
                    header: foo

For more options, see https://collectd.org/wiki/index.php/Plugin:Write_HTTP
