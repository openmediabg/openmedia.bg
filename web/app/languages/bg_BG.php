<?php
$wp_default_secret_key = 'вашата супер-ултра-уникална фраза сложете тук';

function bg_ping_services_add_option($sites) {
	$url = 'http://topbloglog.com/rpc/ping/';
	return (false === strpos($sites, $url))? $url."\n".$sites : $sites;
}

add_filter('option_ping_sites', 'bg_ping_services_add_option');

wp_oembed_add_provider( '#http://(www\.)?vbox7\.com/play:.+#', 'http://vbox7.com/etc/oembed/', true );
