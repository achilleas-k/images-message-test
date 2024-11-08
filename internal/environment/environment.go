package environment

import "github.com/osbuild/images/pkg/rpmmd"

type Environment interface {
	GetPackages() []string
	GetRepos() []rpmmd.RepoConfig_
	GetServices() []string
}

type BaseEnvironment struct {
	Repos []rpmmd.RepoConfig_
}

func (p BaseEnvironment) GetPackages() []string {
	return []string{}
}

func (p BaseEnvironment) GetRepos() []rpmmd.RepoConfig_ {
	return p.Repos
}

func (p BaseEnvironment) GetServices() []string {
	return []string{}
}
