#!/usr/bin/env node

/* global process, console */
if (process.argv.length < 3 || process.argv.length > 4) {
    console.log("Usage: DOCKER_REGISTRY=https://registry.hub.docker.com/" + process.argv[0] + " " + process.argv[1] + " repository [tag]");
    process.exit(2);
}
var repository = process.argv[2];
if (process.argv.length > 3) {
    var chosen_tag = process.argv[3];
}

var when = require('when');
when.keys = require('when/keys');
var superagent = require('superagent');

var api = {
    base: (process.env.DOCKER_REGISTRY || "https://registry.hub.docker.com/") + "v1",
    get: function () {
        var url = '';
        Array.prototype.slice.call(arguments).forEach(function (arg) {
            url = url + '/' + arg;
        });
        return when.promise(function (resolve, reject) {
            superagent.get(api.base + url)
                .end(function (error, result) {
                    if (error) {
                        console.info("Error requesting " + api.base + url);
                        reject(error);
                    } else if (result.ok) {
                        resolve(result.body);
                    } else {
                        console.info("Error requesting " + api.base + url);
                        reject(result.body);
                    }
                });
        });
    },
};

var tags = api.get('repositories', repository, 'tags');

when.keys.map(tags, function (image, tag) {
    if (chosen_tag && chosen_tag !== tag) {
        return;
    }
    var cmds = when.map(api.get('images', image, 'ancestry'), function (image) {
        return api.get('images', image, 'json')
            .then(function (details) {
                if (details.container_config.Cmd) {
                    return details.container_config.Cmd[2];
                } else {
                    return null;
                }
            });
    });
    return when.reduce(cmds, function (acc, cmd) {
        if (cmd) {
            return cmd + "\n" + acc;
        } else {
            return acc;
        }
    });
}).done(function (result) {
    if (chosen_tag) {
        if (result.hasOwnProperty(chosen_tag)) {
            console.log(chosen_tag);
            console.log(result[chosen_tag]);
        } else {
            console.log("Tag " + chosen_tag + " of " + repository + " not found");
        }
    } else {
        for (var tag in result) {
            if (result.hasOwnProperty(tag)) {
                console.log(tag);
                console.log(result[tag]);
            }
        }
    }
}, console.error);
