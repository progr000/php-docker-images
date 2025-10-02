<?php
if (isset($argv[1])) {
    $output_file = "/tmp/cron-test-out/" . basename($argv[1]);
} else {
    $output_file = "/tmp/cron-test-out/execute-cron-every-minute-example-" . date("Ymd_His") . ".txt";
}

exec('rm -rf /tmp/cron-test-out/execute-cron-every-minute-example-*.txt');
file_put_contents($output_file, date('Y-m-d H:i:s'));
