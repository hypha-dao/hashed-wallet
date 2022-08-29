# Run normally - no output if nothing changed
docker build --progress=plain -t flutterdocker .

# Run without cache to see all output - takes a long time
# docker build --progress=plain --no-cache -t flutterdocker .
