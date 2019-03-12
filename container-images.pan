template features/arc-ce/container-images;

# Define the container images used by all ARC CEs and UIs

variable HTCONDOR_DOCKER_IMAGES = {
    images = dict(
        'el6', dict(
            'repository', 'stfc/grid-workernode-c6',
            'tag', '2019-04-09.1',
        ),
        'el7', dict(
            'repository', 'stfc/grid-workernode-c7',
            'tag', '2019-04-09.1',
        ),
    );

    results = dict();

    foreach(os; details; images) {
        # Check that the tag exists in the latest hourly scrape of DockerHub API data and throw an error if not
        taglist = json_decode(file_contents(format(
            'external_data/docker/%s/tags.json',
            details['repository'],
        )));

        if (index(details['tag'], taglist) < 0) error(
            'Tag %s does not exist in repository %s',
            details['tag'],
            details['repository'],
        );

        result[os] = format('%s:%s', details['repository'], details['tag']);
    };

    result;
};
