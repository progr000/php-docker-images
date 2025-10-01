<?php
if (isset($argv[1])) {
    $output_file = "/cron-test-out/" . basename($argv[1]);
} else {
    $output_file = "/cron-test-out/execute-cron-every-minute-example-" . date("Ymd_His") . ".txt";
}

exec('rm -rf /cron-test-out/execute-cron-every-minute-example-*.txt');
file_put_contents($output_file, date('Y-m-d H:i:s'));
