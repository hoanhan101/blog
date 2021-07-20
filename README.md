# blog

## Developing

After cloning the project, make sure to update the theme (git submodule) too:
```
git submodule update --init --recursive
```

Run the project:
```
make up
```

Note that, a Makefile is also added for the ease of development. For more information, simply run `make`:
```
help                 Print usage information
post                 Create a new post
up                   Start Hugo server
```


## Deploying

Each Git push deploys to [Netlify](https://www.netlify.com/). Final build is available at [hoanhan.co](https://hoanhan.co/).
