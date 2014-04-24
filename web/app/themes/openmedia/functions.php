<?php

// Remove the Masonry script used for the footer in Twenty Thirteen
function openmedia_dequeue_masonry() {
	wp_dequeue_script( 'jquery-masonry' );
}
add_action( 'wp_print_scripts', 'openmedia_dequeue_masonry' );
