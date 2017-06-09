pip install twine

	echo "This is default build. Deployment will be done to to PyPI entry htcondor-python."

if [ -n "$TRAVIS_TAG" ]; then
	twine upload -u ${USER} -p ${PASS} --skip-existing ${TRAVIS_BUILD_DIR}/wheelhouse/htcondor-python*;
else
	echo "Tag not set, deployment skipped.";
fi
