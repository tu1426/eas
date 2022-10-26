#!/bin/bash
#cd main

# remove target files
rm -rf "./target" | true

# create folder
mkdir -p "./target"
mkdir -p "./target/fitDistribution_bin"

# set platforms for building
PLATFORMS=("windows/amd64" "darwin/amd64" "darwin/arm64" "linux/amd64")
: 'possible OS/ARCH combinations:
GOOS - Target Operating System	GOARCH - Target Platform
android	arm
darwin	386
darwin	amd64
darwin	arm
darwin	arm64
dragonfly	amd64
freebsd	386
freebsd	amd64
freebsd	arm
linux	386
linux	amd64
linux	arm
linux	arm64
linux	ppc64
linux	ppc64le
linux	mips
linux	mipsle
linux	mips64
linux	mips64le
netbsd	386
netbsd	amd64
netbsd	arm
openbsd	386
openbsd	amd64
openbsd	arm
plan9	386
plan9	amd64
solaris	amd64
windows	386
windows	amd64
'

# build
for PLATFORM in "${PLATFORMS[@]}"; do
	SPLIT=(${PLATFORM//\// })
	GOOS=${SPLIT[0]}
	GOARCH=${SPLIT[1]}

	OUTNAME="fitDistribution-$GOOS-$GOARCH"

	if [ $GOOS = "windows" ]; then
	  OUTNAME+='.exe'
	fi

  env GOOS=$GOOS GOARCH=$GOARCH go build -o ./target/$GOOS/$OUTNAME

  if [ $? -ne 0 ]; then
    echo "Error occured on building $OUTNAME"
    exit 1
  else
    echo "Built $OUTNAME"
  fi

  # create zip file
  cd ./target
  zip -r -X "./fitDistribution_bin/$GOOS.zip" "./$GOOS/" > /dev/null 2>&1
  echo "Compressed $GOOS.zip"

  cd ..
done

# compress source files
zip -r -X "./target/sourceFiles.zip" "./sourceFiles/" > /dev/null 2>&1
echo "Compressed sourceFiles.zip"

# copy source files to bin
cp "./target/sourceFiles.zip" "./target/fitDistribution_bin"

# create zip file
cd ./target
zip -r -X "./fitDistribution.zip" "./fitDistribution_bin" > /dev/null 2>&1
echo "Compressed fitDistribution.zip"

# move file to bin folder
cp "./fitDistribution.zip" "../../../bin/fitDistribution.zip"

echo "Build done"
