Description
===========

This is a little program that monitors network throughput and outputs it continuously in a format that can be used in conjunction with i3bar to display a textual (ASCII) sparkline graph. You will need [spark](https://github.com/holman/spark) for this.


In my ~/.config/i3/config:
```
bar {
	status_command network_spark.sh
	...
}
```

In my ~/.config/i3status:
```
general {
	output_format = "none"
	...
}
```

Usage
=====

```
network_spark.sh [interface [i3status-config]]
```
The script can simply be used without parameters as described above. Alternatively, you can specify

* _interface_ the name of the network interface to monitor
* _i3status-config_ the path of the i3status configuration file.
