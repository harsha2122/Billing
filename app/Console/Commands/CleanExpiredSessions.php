<?php

namespace App\Console\Commands;

use App\Models\UserSession;
use Carbon\Carbon;
use Illuminate\Console\Command;

class CleanExpiredSessions extends Command
{
    protected $signature = 'sessions:clean {--days=30 : Inactivity threshold in days}';

    protected $description = 'Remove user sessions that have been inactive for the given number of days (default: 30)';

    public function handle()
    {
        $days = (int) $this->option('days');

        $deleted = UserSession::where('last_active_at', '<', Carbon::now()->subDays($days))
            ->delete();

        $this->info("Cleaned {$deleted} expired session(s) (inactive > {$days} days).");

        return 0;
    }
}
