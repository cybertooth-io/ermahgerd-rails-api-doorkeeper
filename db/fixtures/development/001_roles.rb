Role.seed_once(
        :key,
        {
            key: 'ADMIN',
            name: 'Administrator',
            notes: 'An administrator role that will have permission to create, update, and delete almost everything.'
        },
        {
            key: 'GUEST',
            name: 'Guest',
            notes: 'An authenticated guest role.  Permissions vary.'
        }
)
