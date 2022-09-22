package helloworld
import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
    "universe.dagger.io/yarn"
    "universe.dagger.io/bash"
)
dagger.#Plan & {
    client: {
        env: {
            VERCEL_TOKEN: VERCEL_TOKEN
        }
        filesystem:{
            "./tmp-example":{
                write: contents: actions.deploy.run.export.directories."/tmp"
            }
        }
    }
	actions: {
        source: core.#Source & {
            path: "."
            exclude: [
                "node_modules",
                "build",
                "*.cue",
                ".git",
            ]
        }

        build: yarn.#Script & {
            name: "build"
            source: actions.source.output
        }

        test: yarn.#Script &{
            name: "test"
            source: actions.source
        }


        deploy: run: bash.#RunSimple & {
            always: true
            args: [client.env.VERCEL_TOKEN]
            script: contents: #"""
            yarn add -g vercel
            vercel --token $1 --yes
            """#
            export: directories: "/tmp": dagger.#FS
            }
	}
}