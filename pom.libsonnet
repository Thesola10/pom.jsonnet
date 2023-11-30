local Header = '<?xml version="1.0" encoding="UTF-8"?>\n';

local ProjectTag = '<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">';

local Tag(key, value) = '<' + key + '>' + value + '</' + key + '>';

local RealizeXml(obj) =
  if std.isObject(obj)
  then
    std.foldl(function(l, r) l + Tag(r.key, RealizeXml(r.value))
              , std.objectKeysValues(obj)
              , '')
  else if std.isArray(obj)
  then
    std.foldl(function(l, r) l + RealizeXml(r)
              , obj
              , '')
  else obj;

local Artifact(group, id, version) = { groupId: group, artifactId: id, version: version };

local Project(o) = Header + ProjectTag + RealizeXml(o) + '</project>';

{
  Project(o):: Project(o { modelVersion: '4.0.0' }),
  Artifact(group, id, version):: Artifact(group, id, version),
  Dependency(group, id, version):: { dependency: Artifact(group, id, version) },
  TestDependency(group, id, version):: { dependency: Artifact(group, id, version) { scope: 'test' } },
  Plugin(group, id, version, extras={}):: { plugin: Artifact(group, id, version) + extras },
  Execution(phase, goals):: { execution: { phase: phase, goals: goals } },
}
