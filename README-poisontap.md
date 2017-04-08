# POISONTAP RASPBIAN BUILD ENVIRONMENT

## What Is PoisonTap?

PoisonTap is a mean exploitation and exfiltration tool from Samy Kamkar. You can read more about it below.

- [Samy Kamkar's write-up on PoisonTap](https://samy.pl/poisontap/)
- [PoisonTap GitHub](https://github.com/samyk/poisontap)

---

## PoisonTap Specific Configuration Options

You will need to define `POISONTAP_ENDPOINT` in your base config file (`./config`) with the format of `DOMAIN:PORT`.

**note:** If you modify the port from the default `1337` you will have to modify the listening port in the [backend_server.js](https://github.com/samyk/poisontap/blob/master/backend_server.js#L5) file as well.

---

## Building

As always, become familiar with the standard [README](https://github.com/KhasMek/pi-gen/blob/dev/README.md) and build process for pi-gen. I like using Docker to build, it takes a lot of the pita out of the process and cleanup.

I traditionally only build this up through the stage2.5 and save some time/space compiling. PoisonTap runs headless, so there is no real reason for any of the additional *fluf* that stages three and four provide. To each their own though, and if you'd like to build this out to a later stage, just skip the commands that involve touching the SKIP and removing the EXPORT* files. Additionally stage2.5 NOOBs packages aren't built by default. If you'd like a NOOBs package just `cp stage2.5/EXPORT_IMAGE stage2.5/EXPORT_NOOBS`.

##### Building through stage2.5 on initial clone

```bash
rm stage4/EXPORT*
touch stage3/SKIP stage4/SKIP
echo "POISONTAP_ENDPOINT=mydomain.com:1337" >> config
./build-docker.sh
```

**note:** This assumes you have already installed all necessary dependencies to build pi-gen.

Once the build completes successfully, you will have `image_${DATE}-Raspbian-poisontap.zip` in the `deploy` directory. You can then extract the archive and flash it to an sdcard. I've tested this on the Raspberry Pi Zero (ver1.0-1.3), but should work fine on the Pi W or any other model of Pi. Please file an issue on GitHub or send me a message if it does not. If there aren't any files in there, your build has failed and you need to look up into the output to see why it failed.

I would recommend booting up with it plugged into a normal outlet on first boot. This is due to rpi-wiggle.sh running on first boot to expand out the partition to encompass the entire size of the sdcard. After that booting and dropping payloads should be pretty quick.

##### Cleaning up

```
docker rm pigen_work && docker rmi $(docker images -q) && docker volume prune -f
```

*note:* you may need to be root/sudo.

The above command will clean up **all** of your docker images. This works fine if all you're using it for is pi-gen related builds. **Do not** use this nuclear option if you use Docker images for other uses on your build system.
