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
