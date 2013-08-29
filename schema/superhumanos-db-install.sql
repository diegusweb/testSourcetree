/****** Object:  Table [dbo].[thc_superhumanos_afichesUsuarios]    Script Date: 10/04/2012 10:47:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[thc_superhumanos_afichesUsuarios](
        [nom] [varchar](50) NULL,
        [ape] [varchar](50) NULL,
        [ema] [varchar](50) NULL,
        [ciu] [varchar](50) NULL,
        [pai] [varchar](50) NULL,
        [cab] [varchar](50) NULL,
        [des] [varchar](50) NULL,
        [id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
        [PosterHash] [varchar](100) NULL,
 CONSTRAINT [PK_afichesUsuarios] PRIMARY KEY CLUSTERED 
(
        [id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
