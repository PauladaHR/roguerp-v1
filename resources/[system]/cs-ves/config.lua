config = {
    -- Set whether you want to be informed in your server's console about updates regarding this resource.
    ['updatesCheck'] = true,

    -- Enabling debug will draw lines useful for debugging, especially when creating a new config entry.
    ['debug'] = false,

    -- If you want to host the DUI files yourself you can find the source at https://github.com/criticalscripts-shop/cs-ves-dui, otherwise leave it as it is.
    ['duiUrl'] = 'https://files.criticalscripts.shop/cs-ves-dui/dui.html',

    -- Strings through-out the resource to translate them if you wish.
    ['lang'] = {
        ['addToQueue'] = 'Add to Queue',
        ['videoToggle'] = 'Video Toggle',
        ['remoteControl'] = 'Remote Control',
        ['play'] = 'Play',
        ['queueNow'] = 'Queue Now',
        ['queueNext'] = 'Queue Next',
        ['remove'] = 'Remove',
        ['pause'] = 'Pause',
        ['stop'] = 'Stop',
        ['skip'] = 'Skip',
        ['loop'] = 'Loop',
        ['volume'] = 'Volume',
        ['invalidUrl'] = 'URL invalid.',
        ['invalidYouTubeUrl'] = 'YouTube URL invalid.',
        ['invalidTwitchUrl'] = 'Twitch URL invalid.',
        ['urlPlaceholder'] = 'YouTube / Twitch URL',
        ['sourceError'] = 'Playable media error occured.',
        ['twitchChannelOffline'] = 'Twitch channel offline.',
        ['twitchVodSubOnly'] = 'Twitch video subs-only.',
        ['twitchError'] = 'Twitch error occured.',
        ['youtubeError'] = 'YouTube error occured.',
        ['sourceNotFound'] = 'Playable media not be found.',
        ['liveFeed'] = 'Live Feed',
        ['twitchClip'] = 'Twitch Clip',
        ['queueLimitReached'] = 'The queue has already too many entries.'
    },

    -- Loading related timeouts, default values should work in most servers.
    ['timeouts'] = {
        ['assetLoadMs'] = 5000
    },

    ['featureDelayWithControllerInterfaceClosedMs'] = 500,

    -- This is a catch-all model entry that will work as a default for all vehicle models that do not have a specific model entry configured.
    -- It is highly recommended to configure model entries on a one-by-one basis as you see fit instead of using this catch-all as it might have a bigger impact on performance, use it at your own discretion.
    ['catchAllModel'] = {
        ['enabled'] = true,
        ['range'] = 32.0,
        ['autoAdjustTime'] = false,
        ['maxVolumePercent'] = 150,

        ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

        ['lowPass'] = {
            ['checkDoors'] = {0, 1, 2, 3, 5},
            ['checkWindows'] = {0, 1}
        },

        ['replacers'] = nil,
        ['monitors'] = nil,

        ['speakers'] = {
            {
                ['soundOffset'] = nil,
                ['directionOffset'] = nil,
                ['maxDistance'] = 16.0,
                ['refDistance'] = 4.0,
                ['rolloffFactor'] = 1.25,
                ['coneInnerAngle'] = 90,
                ['coneOuterAngle'] = 180,
                ['coneOuterGain'] = 0.5,
                ['fadeDurationMs'] = 250,
                ['volumeMultiplier'] = 1.0,
                ['lowPassGainReductionPercent'] = 0
            }
        }
    },

    -- Visit our Discord over at https://criticalscripts.shop/discord to get more model entries and share yours too!

    ['models'] = {
        ['pbus2'] = {
            ['enabled'] = true,
            ['range'] = 128.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 50,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['replacers'] = {
                {
                    ['name'] = 'h4_prop_battle_club_projector',
                    ['texture'] = 'script_rt_club_projector',
                    ['range'] = 32.0
                }
            },

            ['monitors'] = {
                {
                    ['hash'] = 'h4_prop_battle_club_screen',
                    ['position'] = vector3(0.6, 0.0, 0.9),
                    ['rotation'] = vector3(0.0, 0.0, 90.0),
                    ['bone'] = 'misc_b',
                    ['lodDistance'] = 128
                },

                {
                    ['hash'] = 'h4_prop_battle_club_screen',
                    ['position'] = vector3(0.0, 0.0, 0.9),
                    ['rotation'] = vector3(0.0, 0.0, -90.0),
                    ['bone'] = 'misc_b',
                    ['lodDistance'] = 128
                },
                
                {
                    ['hash'] = 'h4_prop_battle_club_screen',
                    ['position'] = vector3(-2.05, -2.0, 1.5),
                    ['rotation'] = vector3(0.0, 0.0, -90.0),
                    ['bone'] = 'pbusspeaker',
                    ['lodDistance'] = 128
                }
            },

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 112.0,
                    ['refDistance'] = 12.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['moonbeam2'] = {
            ['enabled'] = true,
            ['range'] = 80.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 80,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 1, 2, 3, 5},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = nil,
            ['monitors'] = nil,

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['ninefjd'] = {
            ['enabled'] = false,
            ['range'] = 64.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 50,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 2},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = {
                {
                    ['name'] = 'xs_prop_arena_tablet_drone',
                    ['texture'] = 'prop_arena_tablet_drone_screen_d',
                    ['range'] = 8.0
                }
            },

            ['monitors'] = {
                {
                    ['hash'] = 'xs_prop_arena_tablet_drone_01',
                    ['position'] = vector3(0.795, 0.075, 0.0475),
                    ['rotation'] = vector3(7.5, -90.0, 0.0),
                    ['bone'] = 'dashglow',
                    ['lodDistance'] = 64
                }
            },

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['sultan'] = {
            ['enabled'] = true,
            ['range'] = 64.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 50,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 1, 2, 3, 5},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = nil,
            ['monitors'] = nil,

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['rmodx6'] = { -- https://www.gta5-mods.com/vehicles/bmw-x6m-f16-rmod-customs
            ['enabled'] = true,
            ['range'] = 64.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 50,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 1, 2, 3, 5},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = {
                {
                    ['name'] = 'rmodx6',
                    ['texture'] = 'navi',
                    ['range'] = 6.0
                },

                {
                    ['name'] = 'rmodx6',
                    ['texture'] = 'navihinten',
                    ['range'] = 6.0
                }
            },

            ['monitors'] = nil,

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['civictyper'] = { -- https://www.gta5-mods.com/vehicles/2015-honda-civic-type-r-fk2-add-on-rhd
            ['enabled'] = true,
            ['range'] = 64.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 150,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 1, 2, 3, 5},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = {
                {
                    ['name'] = 'fk2',
                    ['texture'] = 'pm',
                    ['range'] = 6.0
                },

                {
                    ['name'] = 'prop_tv_flat_03b',
                    ['texture'] = 'script_rt_tvscreen',
                    ['range'] = 16.0
                }
            },

            ['monitors'] = {
                {
                    ['hash'] = 'prop_tv_flat_03b',
                    ['position'] = vector3(0.03, -0.5, 0.0),
                    ['rotation'] = vector3(0.0, 90.0, 15.0),
                    ['bone'] = 'windscreen_r',
                    ['lodDistance'] = 64
                },

                {
                    ['hash'] = 'sm_prop_smug_speaker',
                    ['position'] = vector3(0.0, -1.3, -0.1),
                    ['rotation'] = nil,
                    ['bone'] = nil,
                    ['lodDistance'] = 64
                }
            },

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        ['audirs6'] = {
            ['enabled'] = true,
            ['range'] = 64.0,
            ['autoAdjustTime'] = false,
            ['maxVolumePercent'] = 150,

            ['idleWallpaperUrl'] = 'https://cdn.discordapp.com/attachments/953435181916754001/1015078682605387856/12122.png',

            ['lowPass'] = {
                ['checkDoors'] = {0, 2},
                ['checkWindows'] = {0, 1}
            },

            ['replacers'] = {
                {
                    ['name'] = 'xs_prop_arena_tablet_drone',
                    ['texture'] = 'prop_arena_tablet_drone_screen_d',
                    ['range'] = 8.0
                }
            },

            ['monitors'] = {
                {
                    ['hash'] = 'xs_prop_arena_tablet_drone_01',
                    ['position'] = vector3(0.42, -0.02, 0.035),
                    ['rotation'] = vector3(-20.5, -90.0, -9.0),
                    ['bone'] = 'dashglow',
                    ['lodDistance'] = 64
                }
            },

            ['speakers'] = {
                {
                    ['soundOffset'] = nil,
                    ['directionOffset'] = nil,
                    ['maxDistance'] = 48.0,
                    ['refDistance'] = 4.0,
                    ['rolloffFactor'] = 1.25,
                    ['coneInnerAngle'] = 90,
                    ['coneOuterAngle'] = 180,
                    ['coneOuterGain'] = 0.5,
                    ['fadeDurationMs'] = 250,
                    ['volumeMultiplier'] = 1.0,
                    ['lowPassGainReductionPercent'] = 0
                }
            }
        },

        -- Below you can find a full model config entry reference.
        
        -- ['key'] = {
        --     ['enabled'] = boolean,
        --     ['range'] = number,
        --     ['maxVolumePercent'] = number,
        --     ['autoAdjustTime'] = boolean,

        --     ['idleWallpaperUrl'] = string,

        --     ['lowPass'] = {
        --         ['checkDoors'] = {number, ...},
        --         ['checkWindows'] = {number, ...}
        --     },

        --     ['replacers'] = {
        --         {
        --             ['name'] = string,
        --             ['texture'] = string,
        --             ['range'] = number

        --         },
        --         ...
        --     },

        --     ['monitors'] = {
        --         {
        --             ['hash'] = string,
        --             ['position'] = vector3(number, number, number),
        --             ['rotation'] = vector3(number, number, number),
        --             ['bone'] = string,
        --             ['lodDistance'] = number
        --         },
        --         ...
        --     },

        --     ['speakers'] = {
        --         {
        --             ['soundOffset'] = vector3(number, number, number),
        --             ['directionOffset'] = vector3(number, number, number),
        --             ['maxDistance'] = number,
        --             ['refDistance'] = number,
        --             ['rolloffFactor'] = number,
        --             ['coneInnerAngle'] = number,
        --             ['coneOuterAngle'] = number,
        --             ['coneOuterGain'] = number,
        --             ['fadeDurationMs'] = number,
        --             ['volumeMultiplier'] = number,
        --             ['lowPassGainReductionPercent'] = number
        --         },
        --         ...
        --     }
        -- }
    }
}
