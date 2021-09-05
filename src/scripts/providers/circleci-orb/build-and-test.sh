BuildAndTest() {
    echo "Validating orb"
    circleci orb pack src | circleci orb validate -

    echo "Packing orb to orb.yml"
    circleci orb pack src > orb.yml

    echo "BuildAndTest completed"
}
