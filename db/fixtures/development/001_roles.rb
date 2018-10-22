Role.seed_once(
        :key,
        {
            key: 'ADMIN',
            name: 'Administrator',
            notes: 'An administrator role that is likely granted permission to do anything.'
        },
        {
            key: 'RO',
            name: 'Read-Only',
            notes: 'A read-only role that cannot make any calls to destructive actions.'
        }
)
