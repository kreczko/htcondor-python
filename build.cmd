if not exist "%APPVEYOR_BUILD_FOLDER%\htcondor\%BUILD_DIR%" mkdir "%APPVEYOR_BUILD_FOLDER%\htcondor\%BUILD_DIR%"

cd htcondor

if %ENABLE_CONTRIB% EQU 1 (

  if %PYTHON_VERSION% GEQ 3 cmake -G "%BUILD_ENV%" -H"." -B"%BUILD_DIR%" -Dhtcondor_EXTRA_MODULES_PATH=../htcondor_contrib/modules -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DPYTHON3_EXECUTABLE="%PYTHON%/python.exe" -DPYTHON3_LIBRARY="%PYTHON%/libs/python3*.lib" -DPYTHON3_INCLUDE_DIR="%PYTHON%/include" -Wno-dev
  if %PYTHON_VERSION% LSS 3 cmake -G "%BUILD_ENV%" -H"." -B"%BUILD_DIR%" -Dhtcondor_EXTRA_MODULES_PATH=../htcondor_contrib/modules -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -Wno-dev

) else (

  if %PYTHON_VERSION% GEQ 3 cmake -G "%BUILD_ENV%" -H"." -B"%BUILD_DIR%" -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DPYTHON3_EXECUTABLE="%PYTHON%/python.exe" -DPYTHON3_LIBRARY="%PYTHON%/libs/python3*.lib" -DPYTHON3_INCLUDE_DIR="%PYTHON%/include" -Wno-dev
  if %PYTHON_VERSION% LSS 3 cmake -G "%BUILD_ENV%" -H"." -B"%BUILD_DIR%" -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -Wno-dev

)

cd %BUILD_DIR%

cmake --build . --config Release

cd ..\..
cd

if %PYTHON_VERSION% GEQ 3 xcopy "%APPVEYOR_BUILD_FOLDER%\htcondor\%BUILD_DIR%\lib\python3\Release\*.pyd" .\htc /I
if %PYTHON_VERSION% LSS 3 xcopy "%APPVEYOR_BUILD_FOLDER%\htcondor\%BUILD_DIR%\lib\RELEASE\*.pyd" .\htc /I
xcopy "%APPVEYOR_BUILD_FOLDER%\htcondor\%BUILD_DIR%\bin\Release\*.dll" .\htc /I

dir

"%PYTHON%/python.exe" setup.py bdist_wheel
